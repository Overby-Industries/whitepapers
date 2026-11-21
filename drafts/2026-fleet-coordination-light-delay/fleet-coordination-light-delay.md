# Overby Industries: Releasing Work Only on Evidence — Task Assignment for a Fleet Behind Light Delay

### Version 0.1 — Draft for Community Review

**Author:** Overby Industries R&D Division

---

## Abstract

A fleet of mining pods, refineries, debris reclaimers and shuttles is coordinated from the ground over links whose one-way delay runs from under a second in low Earth orbit to many minutes at a near-Earth asteroid, and which drop out. A coordinator that hears nothing from a vehicle holding a task cannot tell a vehicle that has failed from one that is working normally behind a dead link, and over light-minutes the second case is the ordinary one. This paper describes the task-assignment rule adopted in the Starlifter OS coordinator and the reasoning behind it: **a task leaves a node only on evidence, and silence is never evidence.** Assignments are offers with a deadline, so a lost offer can be recognised from the node's own later report without a retransmission timer. A task held by a silent node is reported as *in doubt* and left where it is, never handed to a second vehicle. The paper states what this costs, which is stranded work, and what it assumes, which is clocks that agree to within a margin and a single coordinator. It reports what a deterministic simulation does and does not show. It is a design record for a first slice, not flight software, and it is deliberately conservative about what it claims.

---

## 1. The problem

Starlifter OS coordinates vehicles that each run their own control software: reclaimer pods in low Earth orbit, refineries and miners at a near-Earth asteroid, shuttles between them. The coordinator offers each a task, such as capturing a piece of debris or processing a load of regolith, and the vehicle does the work and reports. The links between them are slow, delayed and intermittent. In the simulation described in section 6, the asteroid nodes sit 40 seconds from the coordinator in each direction. Real one-way light time to a near-Earth object ranges from seconds to many minutes depending on geometry, and a link can drop for much longer than that.

Task assignment over such a link has two ways to go wrong, and they cost differently.

- **Lost work.** A task is assigned and nobody does it. The cost is a delay, and usually a recoverable one.
- **Duplicated work.** Two vehicles are both sent to the same task. For processing this is waste. For capturing a piece of debris it is worse than waste: two vehicles manoeuvring toward one object is a hazard in its own right.

The difficulty is that a coordinator which has stopped hearing from a node holding a task cannot tell which case it is in. The node may have failed. It may equally be fine, working, with the failure on the link, either direction of it. In an asynchronous system with unbounded delay, a slow process and a dead one cannot be told apart, which is the same indistinguishability that underlies the impossibility of consensus with even one faulty process [1]. Across light-minutes this is not a rare corner case. It is the normal condition of the link.

A scheduler that reassigns a task when its holder has been quiet for some timeout therefore solves lost work by taking on duplicated work, routinely, whenever a healthy node goes quiet for a while. The question this paper answers is what to do instead.

## 2. Three commitments

The design rests on three commitments, each of which is also a constraint on the others.

**Local autonomy first.** No node depends on the coordinator for anything safety-critical, and the coordinator cannot command a vehicle's own safety response. A vehicle that loses contact finishes the task it holds, then holds a local default such as station-keeping. It does not stop because the coordinator went quiet. A vehicle whose own control software puts it into safe mode abandons its task, and says so.

**Assignments are offers.** The coordinator does not command. It offers one task to one node, with a deadline. The node checks what it can, then asks its own control software, which has the final say. The node answers: accepted, or rejected with a reason. The fleet layer has no way to command a mode change, clear a fault or interrupt a fault response.

**A task leaves a node only on evidence.** The coordinator returns a task to the queue only because the node itself said something that shows it no longer has the work. Silence is not such a statement. A task held by a silent node is visible, counted and left exactly where it is.

The third commitment is the subject of the rest of the paper. The first two are what make it affordable: because a node keeps working through an outage, a silent node is overwhelmingly likely to still be working, and so leaving its task with it is usually correct.

## 3. The evidence rule

### 3.1 What counts as evidence

The coordinator learns everything from packets in the OTF-1 telemetry format, and changes a task's state only because of what one of them says:

| The coordinator receives | It concludes | The task becomes |
|----------------------------------------|--------------------------------|----------------------------|
| An acknowledgement, accepted | The node took it | Active |
| A status listing the task as active | The node took it | Active |
| A completion event carrying the task's id | The work is done | Completed |
| A status listing the task as completed | The work is done | Completed |
| An acknowledgement, rejected | The offer was not taken | Queued |
| A status listing the task as failed | The node abandoned it | Queued, or failed after three attempts |
| A status sent after the offer's deadline that does not list an unanswered offer | The offer was never taken | Queued |
| A status newer than the acceptance that no longer lists the task | The node lost it, most likely by restarting | Queued, counted as a failure |
| Nothing | Nothing | Unchanged, and shown as *in doubt* once the node is marked lost |

Every row but the last is something a node said. The last row is the point.

### 3.2 The offer deadline

Each offer carries a deadline: the time it was sent, plus the one-way delay last observed from that node, plus an accept window (ten seconds by default). A node must refuse an offer that arrives after the deadline.

This does two jobs. It bounds how stale an offer can be when it finally lands after minutes in transit. And it gives the coordinator a way to reason about an offer that was never answered, which is the seventh row of the table. A node may take an offer only before the deadline, so a status the node sent after the deadline reflects its final decision. If the task is not in that status, the offer was not taken, whichever packet was the one that got lost: the offer, or the acknowledgement. A lost offer is therefore recovered from the node's own later report, with no retransmission timer.

The comparison sets a node's clock against the coordinator's, so a margin (one second by default) is added to it. Section 7 returns to that.

### 3.3 In doubt

A task offered to, or held by, a node that has been silent past a timeout is reported as *in doubt*. The timeout changes how the node is described and stops new offers going to it. It moves no work. If the node comes back, its next status settles the matter by one of the rows above: finished, still working, or no longer holding it. If it never comes back, the task waits.

Releasing an in-doubt task anyway is a judgement about risk: is duplicated work worse than undone work, for this task, now? That is a question for a human or an advisory layer that can weigh the specific hazard, not for a scheduler applying a timer. It is not built.

### 3.4 Why not a lease

The standard answer to a holder that may have gone quiet is a lease [2]: the holder's claim expires after a term, after which the resource can safely be given to someone else, provided the holder stops using it when its own lease runs out.

The offer deadline is exactly a lease on the *offer*, and it works for the reason leases work: the node honours the expiry. After acceptance a lease would need the node to abandon the work when its term ends. That conflicts with the first commitment, because a node that keeps working through an outage cannot at the same time stop working when a timer says the coordinator has given up on it. And abandoning physical work partway, such as a capture under way, is not free and not obviously safe.

So the two designs make different trades. A lease buys liveness, since work always comes back, at the cost of waste and of abandonment. The evidence rule buys safety, since no task is ever done twice because of a timeout, at the cost of stranded work. Which is right depends on the task. For debris capture, where a duplicated manoeuvre is a hazard, safety was preferred. This is a judgement and is recorded here as one. A fleet doing only processing, where duplication is merely wasteful, might reasonably choose the other way.

## 4. Snapshots, order and restarts

Packets over such a link arrive late, twice and out of order, and the design has to be correct when they do.

**A status is a snapshot, not a change.** Every status carries everything: health, the node's own view of its link, its capabilities, its location, and the task it holds or last finished, with that task's outcome kept in every status until a newer task replaces it. A coordinator that missed any number of earlier packets is fully caught up by the next one. This is what lets a lossy link be survivable without retransmission.

**A node's packets are ordered by timestamp, then by sequence number.** A status or heartbeat that is not newer than what has been applied is discarded. Timestamp comes first so that a node which restarts and counts from zero again is still understood. A sequence number alone would make the restarted node's packets look old.

**An acknowledgement advances the node's position in that order.** The case this exists for: a status sent just before a node took a task arrives just after its acceptance. Read naively it says "I do not hold that task", which is the eighth row of the table, and would send the work to a second node. Because the acceptance moved the node's position forward, the older status is recognised as older and discarded. For example, a node sends status A at 12:00:00.500 and accepts the offer at 12:00:01.000. Over a delayed link the acceptance arrives first and A arrives after it, and A must not be read as the node's state after accepting. The case is subtle enough to have its own test, and the test fails if the acknowledgement stops advancing the node's position.

**A completion is recorded once.** Events are the public record, and a repeated packet would double-count the mass credited toward the cleanup index. They are recorded once per pod and task, however often they arrive.

## 5. Store and forward

Work finished during an outage is the record that matters most and is most likely to be lost. A node therefore holds completion events on board while it considers itself out of contact, and sends them when the coordinator is heard again. Status keeps going out regardless, because a node cannot know that its own transmissions are the half of the link that failed.

Two consequences follow. A completed task's outcome reaches the coordinator through the status even if the event never does, so the task is settled either way. And one failure remains: an event sent into a link that has failed without the node noticing is lost from the public feed, although the task's outcome still arrives by status.

## 6. What a simulation shows

The coordinator, the on-vehicle agent and a simulator of delayed, interruptible links are implemented in C++17 with no dependencies, in the `starlifter-os` repository. The simulation is deterministic: no randomness and no wall clock, so a scenario replays identically.

The reference scenario runs one coordinator and five nodes for twenty simulated minutes, with four things going wrong.

| What goes wrong | What happens |
|----------------------------|--------------------------------------------------|
| Two pods at a near-Earth asteroid are 40 light-seconds away | Offers carry a deadline that allows for the trip, so nothing arrives already expired |
| A reclaimer faults and safes itself mid-task | It reports the task failed, the task returns to the queue and another reclaimer completes it. The faulted node is offered nothing further |
| A refinery drops out of contact for five minutes mid-task | It finishes alone and holds the record on board. When the link returns, its own report settles the task, with nothing duplicated |
| A miner goes silent for good just as it is offered work | The task is marked in doubt and stays with it. It is not handed to another node |

Eight of nine tasks complete. The ninth is in doubt, which is the intended outcome for that node. Of 1,479 packets sent, 459 were lost to outages. No task was recorded as done more than once, and no node was found working on a task it was not given. Every packet on the wire validates against the OTF-1 JSON Schema when checked by code that shares nothing with the C++, and the wire log is byte-identical across two compilers and across release and sanitizer builds.

The test suite has 295 checks. To test the tests, the code was deliberately broken in fourteen ways, including reassigning work when a node goes silent, applying stale statuses and accepting expired offers, and each was caught. That shows the tests would notice a regression of the rules above. It does not show the rules are the right ones.

**What this does not show.** The links are simulated and the pods are stand-ins for real vehicle control software. There is no adversary. Real transports, real clock behaviour and real failures are absent. These results are evidence that the implementation does what this paper says, not evidence about flight.

## 7. Assumptions and limits

- **Clocks agree to within the margin.** The conclusion that an offer was never taken compares a node's timestamp with the coordinator's deadline. A node whose clock runs ahead by more than the margin could have that conclusion drawn about an offer it then accepts, and the task would be handed on. Nothing measures or corrects skew.
- **Senders are who they say they are.** A node acts on any packet naming its configured coordinator. The format has no signature field.
- **There is one coordinator, and its state is in memory.** A restarted coordinator relearns the fleet from the next round of statuses but has forgotten every task it issued.
- **Stranding is a real cost.** A node lost for good strands its task until someone releases it, and release is not built. There is no cancel message either, so a conflict, meaning a node working on a task it was not given, is reported and never acted on.
- **Scheduling is first-come.** There are no priorities, deadlines or accounting for propellant and power.
- **Corrupt packets are dropped, not repaired.** The decoder is strict, so a corrupted packet is refused, but the design does not claim a link never corrupts.

## 8. Related work

Delay-tolerant networking, specified for the Bundle Protocol in RFC 9171 [4], is the transport layer this design sits above. It moves bytes under delay and disruption, and takes no view on who should do the work. Leases [2] are discussed in section 3.4. Lamport's logical clocks [3] solve ordering without synchronised clocks; here each source has a single sequence and a timestamp, and the design leans on a bounded clock margin instead, which is simpler and is exactly the assumption section 7 flags.

## 9. Open questions

- **How to release an in-doubt task.** What information should inform the decision (how long the node has been silent, its last reported progress, the hazard of a duplicate against the cost of waiting), who decides, and whether any rule can be pre-approved for the cases that cannot wait for a human.
- **Measuring skew instead of assuming it.** The margin could be derived from observed round trips rather than set to a constant.
- **A replicated coordinator.** Whether the evidence rule survives when two coordinators each hold part of the picture, and who is entitled to settle a task.
- **A decentralised alternative.** Whether a swarm without a coordinator can make the same guarantee, or only a weaker one.

## References

1. M. J. Fischer, N. A. Lynch and M. S. Paterson, "Impossibility of distributed consensus with one faulty process," *Journal of the ACM*, vol. 32, no. 2, pp. 374–382, 1985.
2. C. Gray and D. Cheriton, "Leases: An efficient fault-tolerant mechanism for distributed file cache consistency," *Proceedings of the 12th ACM Symposium on Operating Systems Principles*, pp. 202–210, 1989.
3. L. Lamport, "Time, clocks, and the ordering of events in a distributed system," *Communications of the ACM*, vol. 21, no. 7, pp. 558–565, 1978.
4. S. Burleigh, K. Fall and E. Birrane, "Bundle Protocol Version 7," RFC 9171, 2022.
5. Overby Industries, *starlifter-os*: <https://github.com/Overby-Industries/starlifter-os> (see `docs/fleet-coordination.md`).
6. Overby Industries, *telemetry-protocol*, the OTF-1 specification: <https://github.com/Overby-Industries/telemetry-protocol>.
