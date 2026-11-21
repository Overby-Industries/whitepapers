# Overby Industries: A Coordinate Is Not Enough — Binding Mission and Spending Records to a Tamper-Evident Ledger

### Version 0.1 — Draft for Community Review

**Author:** Overby Industries R&D Division

---

## Abstract

Two Overby formats, OTF-1 for mission telemetry and OTB-1 for spending, each carry a field meant to hold proof that a record exists and has not been altered, and both describe it as a blockchain token. The Overby Ledger replaces the token with a coordinate into a free, hash-chained, append-only record: protocol version, sequence number and entry hash. This paper observes that a coordinate alone is not enough. It proves that an entry exists and is unaltered. It does not prove the entry is about the packet that carries it, so a valid token pasted into an unrelated record still checks out. We describe a bridge that closes the gap by making each ledger entry commit to a SHA-256 digest of the packet it records, the circularity that creates and how it is broken, the canonical form that makes the digest reproducible, and how the ledger's central protection, that people are committed rather than named, is kept intact when the packet that points at the ledger is public. We state what is tested, including a reference for the canonical form written in independent code, and what is not solved.

---

## 1. The problem

OTF-1 reports mission events: a piece of debris captured, a load of regolith refined. OTB-1 reports spending: land bought, a laboratory built, steel procured. Each has a field, `ProofOfCleanupToken` in OTF-1 and `ProofOfInvestmentToken` in OTB-1, intended to hold "proof this record exists and has not been altered", and both were first described as blockchain tokens.

The Overby Ledger is a free alternative. It is a hash-chained, append-only record with no token, no consensus and no fee, in which anyone may hold a copy and verify it independently. It does the token's job at no cost, and its design documentation argues that the audience these formats address, regulators and insurers, has little reason to be reassured by a chain. The two fields stay in the schemas as plain strings, and what changes is that the value is a ledger coordinate:

    otp:1:8412:9f3c1a4e77b20d51

That is: the coordinate format version, the entry's sequence number, and the entry's hash as 16 hexadecimal digits. Issuing one costs nothing, and checking one needs a copy of the ledger and nothing else.

The weakness this paper addresses is simple to state. **A coordinate proves an entry exists at that position and has not been altered since. It says nothing about what the entry is about.** A token lifted from one record and written into another still checks out, because the entry it names is perfectly real. For a field whose purpose is to let a reader trust a record, that is not good enough.

## 2. The design in one paragraph

Each ledger entry carries a SHA-256 digest of the packet it records. Verification takes the packet in hand, computes its digest, reads the coordinate from its token field, looks up the entry, checks that the coordinate is valid against the ledger, and checks that the entry's digest equals the packet's. A token in a packet that is not the one the entry recorded fails the second check even though it passes the first.

## 3. The circle, and how it is broken

The obvious design has a problem. The token lives inside the packet. The token is the hash of the entry. The entry commits to the packet. Taken literally, the entry would have to contain its own hash.

The way out is that **the digest is taken over the packet with its token field removed.** Publishing proceeds in a fixed order: compute the digest of the token-free packet, append the entry carrying that digest, learn the new entry's coordinate, and only then write the coordinate into the packet's token field. Verifying reverses the last step. It removes the token again before computing the digest, so the digest is the same before and after stamping. The packet is never hashed with the value that depends on its own hash.

## 4. The canonical form

A digest is only useful if two parties get the same one. The same record may be written with its members in a different order, with whitespace, or with a timestamp in a different offset, and none of that should change what was published. If it did, one record could be published twice, and a check could fail for a reason that has nothing to do with tampering.

So the digest is taken over a **canonical form**. The packet is parsed and validated by the reference decoder for its format. Its token field is cleared. It is then re-encoded by the reference encoder, which writes a fixed member order, UTC timestamps, and the shortest number form that reads back as exactly the same value. Anything the decoder rejects is not publishable, which makes publication also a validity gate.

There is an established standard for canonical JSON, RFC 8785 [4]. It was not used because it solves a more general problem: it canonicalises any JSON document. Here the decoder is needed anyway to validate the packet, and re-encoding the decoded value gives a canonical form for free, with the schema's own member order. The price is that the canonical form is defined by the reference implementation, so a verifier in another language has to implement the written specification rather than reuse a library.

That is why the specification is written down and independently reproduced. A short Python script, with no code in common with the C++, reproduces the form from its written description, and the C++ test suite is required to match the script's output byte for byte on every example packet. A change that makes the two disagree fails the build.

## 5. What is recorded

| Ledger field | OTF-1 event | OTB-1 record |
|---------|----------------------------|---------------------------|
| Citation | `OTF-1` | `OTB-1` |
| Kind | `otf1.` plus the action, for example `otf1.captured` | `otb1.` plus the type, for example `otb1.land` |
| Subject | The pod, named. A machine is not a person | The vendor, named or committed (section 6) |
| Standing | Determined | Determined |
| Time | The packet's timestamp in milliseconds since the Unix epoch | The same |
| Detail | `sha256:` and 64 hex digits, then a human-readable summary | The same |

The summary exists so a person reading a diff of a mirrored ledger can see what an entry is about, for example "captured by pod A1, mission orbital-demo-1, task T-0042". It is never trusted: verification reads only the digest.

Only OTF-1 event packets are published. A status, heartbeat, assignment or acknowledgement is bookkeeping between a vehicle and its coordinator, not the public record, and is refused.

## 6. Keeping the asymmetry

The ledger's central design decision is that disclosure is asymmetric. Institutions are named and fully linkable, because pattern over an institution is what a transparency record exists to reveal. People are represented by a keyed commitment that cannot be linked across their own entries or to their identity without a key held separately, because pattern over a person is what enables targeting. A register of everyone ever accused of anything, searchable by name, is how a transparency system becomes an instrument of the harm it was built to surface.

An OTB-1 record names a vendor. The ledger's design distinguishes a legal entity, which is named, from a natural person such as a sole trader, which is committed. The transaction itself stays public. What is hidden is only the counterparty's identity, and only when the counterparty is a person.

A bridge could defeat this without any bug in the ledger. If the ledger committed a person while the packet that points at it named them, nobody would have been protected: the name would sit in public next to the coordinate. So the bridge enforces the rule on both sides.

1. **The caller must classify the vendor.** An OTB-1 record cannot say whether its vendor is a legal entity. The bridge takes the classification as an argument and treats an unclassified vendor as a person. That falls protective for the ledger's own reason: wrongly naming a person cannot be undone, and wrongly protecting a company only means somebody has to ask.
2. **For anyone not established to be a legal entity,** the ledger commits the identity and keeps no trace of it, and the packet the bridge returns has the vendor replaced by a placeholder *before* the digest is taken. The digest, the stamped record and the ledger therefore agree on what was published.

The bridge returns the withheld form and nothing else. The original, un-withheld record is not verifiable: its digest is not the one the ledger holds. The tests check that no trace of a withheld name reaches the ledger's canonical text or its JSON.

What this does not do is also stated. The bridge inspects only the vendor field. A person's name typed into a free-text field such as the item description is not found. The classification is a decision made by the caller and an explicit one, so classifying the same vendor differently is a different record. And the rule is the design's, not a legal conclusion: financial records carry statutory retention that in many jurisdictions overrides erasure, and this needs review by someone qualified before an operations ledger publishes.

## 7. Verification

Verification reports what is wrong rather than only that something is:

| Verdict | Meaning |
|----------------------|----------------------------------------------------------------|
| Verified | The coordinate checks out and its entry commits to this packet |
| Not a packet | The text is not valid OTF-1 or OTB-1 |
| Not publishable | Valid OTF-1, but not an event, so nothing would have been recorded |
| No token | The token field is absent |
| Foreign token | The field holds something that is not a coordinate, such as a legacy blockchain token. It cannot be checked here |
| Malformed token | It looks like a coordinate and is not one |
| Token invalid | The coordinate fails against this ledger: no such entry (a copy that is merely behind), a different hash (altered, or issued by another ledger), or a broken chain |
| Entry mismatch | The coordinate is valid but its entry is about something else: the packet was altered, or the token was lifted |

Two properties are worth stating. A ledger that is merely behind a token, a copy taken before the entry was published, reports a missing entry rather than a forgery, because they are different problems. And a break in the chain after an entry does not invalidate an earlier token: an entry is vouched for by what precedes it.

## 8. Existing tokens, and publishing twice

A packet may already carry something in its token field. The bridge will not overwrite it unless told to, because a token that was meaningful would be lost silently. The example packets in both format repositories all carry legacy tokens, so their tests set the option. A packet carrying a different coordinate from the one the ledger holds for it is refused for the same reason.

Publishing the same record twice appends it once, however it is spelled and whether or not it has already been stamped, because the digest ignores the token. A bridge over a ledger loaded from a copy rebuilds its index from the entries, so a record published in an earlier session is found. A ledger that does not say which ledger it is cannot be published into.

## 9. Evaluation

The tests are adversarial by design, like the ledger's own. Anyone can show that a record published and then checked comes back verified. The tests try every way of presenting one that should not: an altered packet, a token lifted from another record, a coordinate for an entry that does not exist, a coordinate issued by a different ledger, a ledger rewritten after publication, an entry removed from the middle, and a vendor that must not be named.

SHA-256 is checked against the standard's test vectors [1] and against an independent implementation at every padding boundary. The canonical form and digest are required to match the independent reference byte for byte. To test the tests, the code was deliberately broken in fourteen ways, among them a digest that includes the token, a verifier that skips the comparison, a person named in the packet or the ledger, a token silently overwritten and an off-by-one in the hash's padding, and each was caught by a clean assertion failure. That shows the suite would notice such a regression. It does not show the design is complete.

## 10. Limits

- **The chain hash is still FNV-1a, 64 bits.** The digest binding a packet to its entry is SHA-256 and does not inherit that weakness. The entry itself, and so the coordinate, does. That is fine against accident and casual tampering and not sufficient against a determined adversary, as the ledger's own documentation says, and a publisher with real adversaries should substitute a stronger hash.
- **A coordinate names no ledger.** Checking it against the wrong ledger fails with a hash mismatch, because the instance is inside every entry's hash, but a reader is not told which ledger to look in.
- **Commitments are only as private as their key,** and the ledger has no way to notice that the key was never set.
- **A person is found by classification, not detection.**
- **It records what is handed to it.** Nothing here stops a publisher choosing not to publish an event. That is the job of the ledger's gap-free sequence numbers and of distributed copies.
- **Verification is linear.** Checking a coordinate walks the chain.

## 11. Related work

Tamper-evident logging has a body of work behind it [6], and Certificate Transparency [5] made one design, a Merkle tree with compact inclusion proofs, widely deployed. The ledger described here is a hash chain, which is simpler and gives linear verification, where a Merkle tree would give logarithmic inclusion proofs a verifier could check without holding the whole ledger. Moving to one is an open question below. Canonical JSON is the subject of RFC 8785 [4], discussed in section 4. The packets use JSON [2] and RFC 3339 timestamps [3].

## 12. Open questions

- **A Merkle structure.** Whether compact inclusion proofs are worth the added complexity, so that a reader can check one coordinate without holding the whole ledger.
- **A stronger entry hash,** and whether the coordinate should carry a longer one.
- **The instance in the coordinate,** so a reader is told which ledger to consult.
- **A signature layer** binding a ledger to a publisher's key, and where that key is held.
- **The classification rule,** and who may review it before an operations ledger publishes.

## References

1. National Institute of Standards and Technology, "Secure Hash Standard (SHS)," FIPS PUB 180-4, 2015.
2. T. Bray (ed.), "The JavaScript Object Notation (JSON) Data Interchange Format," RFC 8259, 2017.
3. G. Klyne and C. Newman, "Date and Time on the Internet: Timestamps," RFC 3339, 2002.
4. A. Rundgren, B. Jordan and S. Erdtman, "JSON Canonicalization Scheme (JCS)," RFC 8785, 2020.
5. B. Laurie, A. Langley and E. Kasper, "Certificate Transparency," RFC 6962, 2013.
6. S. A. Crosby and D. S. Wallach, "Efficient data structures for tamper-evident logging," *Proceedings of the 18th USENIX Security Symposium*, 2009.
7. Overby Industries, *overby-transparency-protocol*, the Overby Ledger and its bridge: <https://github.com/Overby-Industries/overby-transparency-protocol> (see `docs/LEDGER.md` and `docs/BRIDGE.md`).
8. Overby Industries, *telemetry-protocol* (OTF-1): <https://github.com/Overby-Industries/telemetry-protocol> and *transparency-protocol* (OTB-1): <https://github.com/Overby-Industries/transparency-protocol>.
