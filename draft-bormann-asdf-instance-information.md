---
v: 3

title: Instance Information for SDF
abbrev: SDF Instance Information
category: std
stream: IETF
consensus: true

docname: draft-bormann-asdf-instance-information-latest
number:
date:
area: "Applications and Real-Time"
workgroup: ASDF WG
keyword:
 - IoT
 - Link
 - Information Model
 - Interaction Model
 - Data Model
venue:
  group: "A Semantic Definition Format for Data and Interactions of Things"
  mail: "asdf@ietf.org"
  github: "ietf-asdf-wg/instance-information"

author:
- name: Carsten Bormann
  org: Universität Bremen TZI
  street: Postfach 330440
  city: Bremen
  code: D-28359
  country: Germany
  phone: +49-421-218-63921
  email: cabo@tzi.org
- name: Jan Romann
  org: Hochschule Emden/Leer
  email: jan.romann@hs-emden-leer.de
  country: Germany

normative:
  I-D.ietf-asdf-sdf: sdf
  RFC8288: link
  STD97: http

informative:
  REST:
    target: http://www.ics.uci.edu/~fielding/pubs/dissertation/fielding_dissertation.pdf
    title: Architectural Styles and the Design of Network-based Software Architectures
    author:
    - name: Roy Fielding
      org: University of California, Irvine
    date: 2000
    seriesinfo:
      Ph.D.: Dissertation, University of California, Irvine
  RFC6690: link-format
  I-D.laari-asdf-relations: sdfrel
  I-D.bormann-asdf-sdftype-link: sdflink
  I-D.bormann-asdf-sdf-mapping: mapping
  RFC9423: attr
  I-D.ietf-iotops-7228bis: terms
  I-D.amsuess-t2trg-raytime: raytime
--- abstract

This document discusses types of Instance Information to be used in
conjunction with the Semantic Definition Format (SDF) for Data and
Interactions of Things (draft-ietf-asdf-sdf) and will ultimately
define Representation Formats for them as well as ways to use SDF
Models to describe them.

The present revision is not much more than a notepad; it is expected
that it will be respun at least once before the 2025-04-09 ASDF
meeting.


--- middle

# Introduction

The Semantic Definition Format for Data and Interactions of Things
(SDF, {{-sdf}}) is a format for domain experts to use in the creation
and maintenance of data and interaction models in the Internet of
Things.

SDF is an Interaction Modeling format, enabling a modeler to describe
the digital interactions that a class of Things (devices) offers,
including the abstract data types of messages used in these
interactions.

SDF is designed to be independent of specific ecosystems that specify
conventions for performing these interactions, e.g., over Internet
protocols or over ecosystem-specific protocol stacks.

SDF does not define representation formats for the _Instance Information_ that is
exchanged in, or the subject of such, interactions; this is left to the
specific ecosystems, which tend to have rather different ways to
represent this information.

This document discusses types of Instance Information and will
ultimately define Abstract (eco-system independent) Representation
Formats for them as well as ways to use SDF Models to describe them.

## Conventions and Definitions

The definitions of {{-link-format}}, {{-link}}, and {{-sdf}} apply.

Representation:
: As defined in {{Section 3.2 of RFC9110@-http}}, but understood to
  analogously apply to other interaction styles than Representational
  State Transfer {{REST}} as well.

Message:
: A Representation that is exchanged in, or is the subject of, an
  Interaction.

Instantiation:
: Instantiation is a process that takes a Model, some Context Information, and possibly information from a Device and creates a Message.

Instance:
: Anything that can be interacted with based on the SDF model.
  E.g., the Thing itself (device), a Digital Twin, an Asset Management
  system...
  Instances of a Thing are bound together by some form of identity.

Proofshot:
: A message that attempts to describe the state of an Instance at a
  particular moment (which may be part of the context).
  Proofshots are snapshots, and they are "proofs" in the photographic
  sense, i.e., they may not be of perfect quality.
  Not all state that is characteristic of an Instance may be included
  in a Proofshot (e.g., information about an active action that is not
  embedded in an action resource).
  Proofshots may depend on additional context (such as the identity of
  the Instance and a Timestamp).
  An interaction affordance to obtain a Proofshot may not be provided
  by every Instance.

  Discuss Proofshots of a Thing (device) and of other component.

  Discuss concurrency problems.

  Discuss Timestamps appropriate for Things {{Section 4.4 of -terms}} {{-raytime}}.

{::boilerplate bcp14-tagged-bcp14}

## Terms we are trying not to use

Non-affordance:
: Originally a term for information that is the subject of
  interactions with other Instances than the Thing, this term is now
  considered confusing as it would often just be an affordance of
  another Instance than the Thing.


# Instance Information and SDF

Instantiation doesn't produce an instance (ouch), which is the device,
twin, etc., but a message.

## Pre-structured types of messages

Pre-structured types of messages are those that relate to an SDF model
in a way that, together with context and model, they are fully
self-describing.

### Input and output data of specific interactions

Messages always have context, typically describing the "I" and the
"you" of the interaction, the "now" and "here", allowing deictic
statements ("the temperature here", "my current draw")...

Messages may have to be complemented by this context for
interpretation, i.e., the context needed may need to be reified in the
message (compare the use of SenML "n").

TODO: Use NIPC as an example how this could be used, including SCIM as
a source of context information.

(Describe how protocol bindings can be used to convert these messages
to/from concrete serializations...)

### Proofshots (read device, other component)

(See defn above.)

### Construction

Construction messages enable the creation of the digital instance, e.g., initialization/commissioning of a device or creation of its digital twins.
They are like proofshots, in that they embody a state, however this state needs to be precise so the construction can actually happen.

A construction message for a temperature sensor might assign an
identity and/or complement it by temporary identity information (e.g.,
an IP address); its processing might also generate construction output
(e.g., a public key or an IP address if those are generated on
device).

(Note that it is not quite clear what a destructor would be for a
physical instance -- apart from a scrap metal press, but according to
RFC 8576 we would want to move a system to a re-usable initial state,
which is pretty much a constructor.)

### Deltas and Default/Base messages

What changed since the last proofshot?

What is different from the base status of the device?

Can I get the same (equivalent, not identical) coffee I just ordered but with 10 % more milk?

(Think merge-patch.)

A construction message may be a delta, or it may have parameters that
algorithmically influence the elements of state that one would find in
a proofshot.

## Metadata

One interesting piece of non-affordance information is the model itself, including sdfinfo and the defaultnamespace.  This is of course not about the device or its twin (or even its asset management), because models and devices may want to associate freely.
Multiple models may apply to the same device (including but not only revisions of the models).

# Discussion

(TODO)

# Security Considerations


(TODO)


# IANA Considerations

(TODO)

--- back

# Acknowledgments
{:unnumbered}

(TODO)

