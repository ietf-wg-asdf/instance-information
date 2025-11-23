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
area: ""
workgroup: ASDF
keyword:
 - IoT
 - Link
 - Information Model
 - Interaction Model
 - Data Model
venue:
  group: "»A Semantic Definition Format for Data and Interactions of Things« (ASDF)"
  mail: asdf@ietf.org
  github: "ietf-wg-asdf/instance-information"

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
  org: Universität Bremen
  email: jan.romann@uni-bremen.de
  country: Germany

normative:
  I-D.ietf-asdf-sdf: sdf
  RFC8288: link
  STD97: http
  I-D.ietf-asdf-sdf-nonaffordance: non-affordance

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
  RFC7396: merge-patch
  # I-D.laari-asdf-relations: sdfrel
  # I-D.bormann-asdf-sdftype-link: sdflink
  I-D.bormann-asdf-sdf-mapping: mapping
  # RFC9423: attr
  I-D.ietf-iotops-7228bis: terms
  I-D.amsuess-t2trg-raytime: raytime
  I-D.lee-asdf-digital-twin-09: digital-twin
  LAYERS:
    target: https://github.com/t2trg/wishi/wiki/NOTE:-Terminology-for-Layers
    title: Terminology for Layers
    rc: WISHI Wiki
    date: false
  STP: I-D.bormann-t2trg-stp
  RFC9039: device-id
...

--- abstract

This document discusses types of Instance Information to be used in
conjunction with the Semantic Definition Format (SDF) for Data and
Interactions of Things (draft-ietf-asdf-sdf) and will ultimately
define Representation Formats for them as well as ways to use SDF
Models to describe them.

[^status]

[^status]: The present revision –06 takes into account the discussion that happened during IETF 123 and 124 as well as the interim meetings inbetween, and intends to harmonize different instance message concepts via a common format.


--- middle

{:sdf: pre="yaml2json" check="json" post="fold"}

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

This document discusses types of Instance Information and defines
Abstract (eco-system independent) Representation
Formats for them as well as ways to use SDF Models to describe them.

## Conventions and Definitions

The definitions of {{-link-format}}, {{-link}}, and {{-sdf}} apply.

Terminology may need to be imported from {{LAYERS}}.

Representation:
: As defined in {{Section 3.2 of RFC9110@-http}}, but understood to
  analogously apply to other interaction styles than Representational
  State Transfer {{REST}} as well.

Message:
: A Representation that is exchanged in, or is the subject of, an
  Interaction.
  Messages are "data in flight", not instance "data at rest" (the
  latter are called "Instance" and are modeled by the interaction
  model).

  Depending on the specific message, an abstract data model for the
  message may be provided by the `sdfData` definitions (or of
  declarations that look like these, such as `sdfProperty`) of an SDF
  model.

  Deriving an ecosystem specific representation of a message may be
  aided by _mapping files_ {{-mapping}} that apply to the SDF model
  providing the abstract data model.

Instantiation:
: Instantiation is a process that takes a Model, some Context
  Information, and possibly information from a Device and creates an
  Instance.

Instance:
: Anything that can be interacted with based on the SDF model.
  E.g., the Thing itself (device), a Digital Twin, an Asset Management
  system...
  Instances are modeled as "data at rest", not "data in flight" (the
  latter are called "Message" and actually are/have a Representation).
  Instances that relate to a single Thing are bound together by some
  form of identity.
  Instances become useful if they are "situated", i.e., with a
  physical or digital "address" that they can be found at and made the
  subject of an interaction.

Instance-related Message
: A message that describes the state or a state change of an instance.
  (TBC -- also: do we need this additional term?)

Proofshot:
: A message that attempts to describe the state of an Instance at a
  particular moment (which may be part of the context).
  We are not saying that the Proofshot *is* the instance because there
  may be different ways to make one from an Instance (or to consume
  one in updating the state of the Instance), and because the
  proofshot, being a message, is not situated.

  Proofshots are snapshots, and they are "proofs" in the photographic
  sense, i.e., they may not be of perfect quality.
  Not all state that is characteristic of an Instance may be included
  in a Proofshot (e.g., information about an active action that is not
  embedded in an action resource).
  Proofshots may depend on additional context (such as the identity of
  the Instance and a Timestamp).

  An interaction affordance to obtain a Proofshot may not be provided
  by every Instance.
  An Instance may provide separate Construction affordances instead of
  simply setting a Proofshot.

  Discuss Proofshots of a Thing (device) and of other components.

  Discuss concurrency problems with getting and setting Proofshots.

  Discuss Timestamps appropriate for Things ({{Section 4.4 of -terms}}, {{-raytime}}).

  TODO: Also mention the other message types we had so far (context snapshot,
        context patch, identity manifest) here?

Construction:
: Construction messages enable the creation of a digital Instance,
  e.g., initialization/commissioning of a device or creation of its
  digital twins.
  They are like proofshots, in that they embody a state, however this
  state needs to be precise so the construction can actually happen.

  Discuss YANG config=true approach.

{::boilerplate bcp14-tagged-bcp14}

## Terms we are trying not to use

Non-affordance:
: Originally a term for information that is the subject of
  interactions with other Instances than the Thing (called "offDevice"
  now), this term is now considered confusing as it would often just
  be an affordance of another Instance than the Thing.
  In this draft version, we are trying to use a new keyword called
  `sdfContext` that is supposed to be slightly more accurate, replacing
  the `$context` concept that was used in previous draft versions.

# Instance Information and SDF

The instantiation of an SDF model does not produce an instance, which is, for example, a physical device or a digital twin.
Instead, the instantiation produces an instance-related _message_, which adheres to a uniform message format and is always controlled by the corresponding SDF model.
Depending on the recipient and the purpose of the message, different fields of the message format are present, reporting different kinds of information related to a Thing or causing it to change the state of the Thing when consumed by the recipient.
Taking into account previous revisions of this document as well as {{-non-affordance}}, the potential use cases for instance-related messages indicate the following archetypes:

1. *Context snapshots* that only report context information about a Thing
2. *Proofshots* that report a Thing's state (or parts of it), which may include context information
3. *Delta messages* that indicate state changes compared to a previous context snapshot or proofshot message
4. *Patch messages* that cause a Thing's state to change
5. *Identity manifests* that report information related to a Thing's identity
6. *Construction messages* that initiate a Thing's (re)configuration or its comissioning

These messages may be further clustered into the following three types:

<!-- TODO: The names need to be improved -->

1. *State reports*, both regarding affordances and context information (which includes information about a Thing's identity),
2. *State report updates*, indicating changes that have occurred since a reference state report, and
3. *State patches*, which include the original patch messages as well as construction messages

The uniform message format can be used for all three message types.
{{{#syntax}}} specifies the formal syntax of instance-related messages all normative statements as well as the examples in this document will adhere to.

In the following, we will first outline a number of general principles for instance-related messages, before detailing the specific archetypes we define in this document.
The specification text itself will be accompanied by examples that have been inspired by {{-non-affordance}} and {{-digital-twin}}.

## Axioms for instance-related messages

<!-- TODO: Better integrate this into the document -->

Instance-related messages can be messages that relate to a property, action, or
event (input or output data), or they can be "proofshots" (extracted state
information, either in general or in the form of context snapshots etc.).

Instance-related messages are controlled by a *model*, which normally is the
interaction model of the device (class-level information).
That interaction model may provide a model of the interaction during which the
instance-related message is interchanged (at least conceptually), or it may be a
"built-in" interaction (such as a proofshot, a context snapshot, ...) that is
implicitly described by the entirety of the interaction model.
This may need to be augmented/composed in some way, as device modeling may be
separate from e.g. asset management system modeling or digital twin modeling.
Instance-related messages use JSON pointers into the model in order to link the
instance-related information to the model.

Instance-related messages are conceptual and will often be mapped into
ecosystem-specific protocol messages (e.g., a bluetooth command).
It is still useful to be able to represent them in a neutral ("red-star")
format, which we build here as an adaption of the JSON-based format of the
models themselves.
An ecosystem might even decide to use the neutral format as its
ecosystem-specific format (or as an alternative format).

Instance-related messages may be plain messages, or they may be deltas (from a
previous state) and/or patches (leading from a previous or the current state to
a next state).
Several media types can be defined for deltas/patches; JSON merge-patch {{-merge-patch}} is already in use in SDF (for `sdfRef`) and therefore is a likely candidate.
(Assume that some of the models will be using
[Conflict-free replicated data types (CRDTs)][CRDTs] to facilitate patches.)

[CRDTs]: https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type

To identify the reference state for a delta/patch, we need

* device identity (thingId?)
* state info (timestamp? state/generation identifier?)

### Context Information

Messages always have context, typically describing the "me" and the
"you" of the interaction, the "now" and "here", allowing deictic
statements ("the temperature here", "my current draw")...

Messages may have to be complemented by this context for
interpretation, i.e., the context needed may need to be reified in the
message (compare the use of SenML "n").
Information that enables interactions via application-layer protocols (such as an IP address) can also be considered context information.

For this purpose, we are using the `sdfContext` keyword introduced by {{-non-affordance}}.
Note that `sdfContext` _could_ also be modelled via `sdfProperty`

TODO: explain how {{RFC9039}} could be used to obtain device names (using `urn:dev:org` in the example).

# Message Format {#message-format}

Instance-related messages share a number of structural features with SDF models regarding metadata and namespace information, but are also different in crucial aspects.

## Information Block

The information block contains the same qualities as an SDF model and, additionally, a mandatory `messageId` to uniquely identify the message.
Furthermore, "status report update" messages can utilize the `previousMessageId` in order to link two messages and indicate the state change.

| Quality            | Type             | Description                                                        |
|--------------------|------------------|--------------------------------------------------------------------|
| title              | string           | A short summary to be displayed in search results, etc.            |
| description        | string           | Long-form text description (no constraints)                        |
| version            | string           | The incremental version of the definition                          |
| modified           | string           | Time of the latest modification                                    |
| copyright          | string           | Link to text or embedded text containing a copyright notice        |
| license            | string           | Link to text or embedded text containing license terms             |
| messageId          | string           | Unique identifier of this instance-related message                 |
| previousMessageId  | string           | Identifier used to connect this instance message to a previous one |
| features           | array of strings | List of extension features used                                    |
| $comment           | string           | Source code comments only, no semantics                            |
{: #infoblockqual title="Qualities of the Information Block"}

## Namespaces Block

Similar to SDF models, instance-related messages contain a namespaces block with a `namespace` map and the `defaultNamespace` setting.
In constrast to models, including a `namespace` quality is mandatory as at least one namespace reference is needed to be able to refer to the SDF model the instance-related message corresponds with.

| Quality          | Type   | Description                                                                                          |
|------------------|--------|------------------------------------------------------------------------------------------------------|
| namespace        | map    | Defines short names mapped to namespace URIs, to be used as identifier prefixes                      |
| defaultNamespace | string | Identifies one of the prefixes in the namespace map to be used as a default in resolving identifiers |
{: #nssec title="Namespaces Block"}

## Instance-of Block

Destinct from SDF models are two instance-specific blocks, the first of which is identified via the `sdfInstanceOf` keyword.
Via the `model` keyword, this quality defines the entry point the `sdfInstance` quality from the next section is referring to.
Furthermore, via the `patchMethod` field, a patch algorithm different from JSON Merge Patch can be specified.

| Quality          | Type   | Description                                                                                                                                                    |
|------------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| model            | string | Defines the entry point for `sdfInstance` by pointing to an `sdfObject` or an `sdfThing`. Has to be based on a namespace identifier from the `namespaces` map. |
| patchMethod      | string | Allows for overriding the default patch method (JSON Merge Patch) by providing a registered value.                                                             |
| $comment         | string           | Source code comments only, no semantics                                                                                                              |
{: #iobsec title="Instance-of Block"}

## Instance Block

In the instance block, state information for properties, actions, and events as well as context information can be included.
Depending on the archetype, this information will either be used to report a Thing's current state, to report state _changes_, or to update state via a patch or reconfiguration.

Since we are using the `sdfInstance` keyword as an entry point at the location pointed to via the `model` specfied in `sdfInstanceOf`, the instance message has to follow the structure of this part of the model (although, depending on the archetype, information that has not changed or will not be updated can be left out.)
Note that we might also have to replicate a nested structure via `sdfThing` and/or `sdfObject` if present in the referenced SDF model.

| Quality          | Type   | Description |
|------------------|--------|-------------|
| sdfThing         | map    | TODO        |
| sdfObject        | map    | TODO        |
| sdfContext       | map    | TODO        |
| sdfProperty      | map    | TODO        |
| sdfAction        | map    | TODO        |
| sdfEvent         | map    | TODO        |
{: #ibsec title="Instance Block"}

## Metadata

One interesting piece of offDevice information is the model itself, including sdfinfo and the defaultnamespace.  This is of course not about the device or its twin (or even its asset management), because models and devices may want to associate freely.
Multiple models may apply to the same device (including but not only revisions of the models).

# Message Archetypes

Based on the common message format defined in {{{#message-format}}}, we can derive a set of three archetypes that serve different use cases and recipients.

## State Reports

This instace-related message contains information regarding a Thing's state, both in terms of context information and the state of individual affordances.

TBC

## State Report Updates

TODO

## State Patches

TODO

# Message Purposes and Usecases

As mentioned before, the archetypes can be further subdivided into (at least) six kinds of messages that all deal with different use cases.

## Context Snapshots

Context snapshots are state reports that only include context information via the `sdfContext` keyword.

{{example-context}} gives an example for this kind of instance message.

TODO: Update example

~~~ sdf
info:
  messageId: 8988be82-50dc-4249-bed2-60c9c8797623
namespace:
  models: https://example.com/models
  boats: https://example.com/boats
defaultNamespace: boats
sdfInstanceOf:
  model: models:#/sdfObject/boat
sdfInstance:
  sdfContext:
    "$comment": Potential contents for the SDF context
    deviceName: urn:dev:org:30810-boat007
    deviceEui64Address: 50:32:5F:FF:FE:E7:67:28
    scimObjectId: 8988be82-50dc-4249-bed2-60c9c8797677
~~~
{:sdf #example-context
title="Example of an SDF context snapshot."}

## Proofshots

(See defn above.)

Proofshots are similar to context snapshots, with the important difference that
they are not only reporting the context information associated with an entity but
also state information associated with its interaction affordances (properties,
actions, and events).
TODO: Note that while the format for describing the state of properties is clearly
governed by the schema information from the corresponding `sdfProperty`
definition, it is still unclear how to best model the state of `sdfAction`s and
`sdfEvent`s.
As in the case of the Context Snapshot, the Proofshot may also contain concrete
values that reflect context information associated with a device via the
`sdfContext` keyword {{-non-affordance}}.

The following examples are based on {{-non-affordance}} and {{-digital-twin}}.
{{code-off-device-instance}} shows a proofshot that captures the state of a
sensor.
Here, every property and context definition of the corresponding SDF model
(see {{code-off-device-model}}) is mapped to a concrete value that corresponds
with the associated schema information.

~~~ sdf
info:
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a42
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfInstanceOf:
  model: sensors:#/sdfObject/envSensor
sdfInstance:
  sdfContext:
    timestamp: '2025-07-01T12:00:00Z'
    thingId: envSensor:abc123
    installationInfo:
      mountType: ceiling
  sdfProperty:
    temperature: 23.124

~~~
{:sdf #code-off-device-instance post="fold"
title="SDF proofshot example."}

## Construction Messages

Construction messages enable the creation of the digital instance, e.g., initialization/commissioning of a device or creation of its digital twins.
As they change the state of the device, they fall into the third category of state patches.
Construction messages are like proofshots, in that they embody a state, however this state needs to be precise so the construction can actually happen.

A construction message for a temperature sensor might assign an
identity and/or complement it by temporary identity information (e.g.,
an IP address); its processing might also generate construction output
(e.g., a public key or an IP address if those are generated on
device). This output -- which can once again be modeled as an instance message
-- may be referred to as an *identity manifest* when it primarily contains
identity-related context information.

Construction messages need to refer to some kind of constructor in order to be able to start the actual construction process.
In practice, these constructors are going to be modeled as an `sdfAction`,
although the way the `sdfAction` is going to be used exactly is not entirely
clear yet.
As the device that is being constructed will not be initialized before the
construction has finished, the `sdfAction` has to be modeled as an external or
"off-device" action. This raises the question whether the `sdfAction` still
belongs into the SDF model that corresponds with the class the resulting device
instance belongs to.

(Note that it is not quite clear what a destructor would be for a
physical instance -- apart from a scrap metal press, but according to
RFC 8576 we would want to move a system to a re-usable initial state,
which is pretty much a constructor.)

{{code-sdf-construction-message}} shows a potential SDF construction message
that initializes a device. As shown above, the information from the message
ends up in both an SDF Model (or Mapping File) and an instance message.

TODO: Update example

~~~ sdf
info:
  title: Example SDF construction message
  "$comment": 'TODO: What kind of metadata do we need here?'
namespace:
  cap: https://example.com/capability/cap
defaultNamespace: cap
sdfInstanceOf:
  model: cap:#/sdfObject/temperatureSensor/sdfConstructors/construct
sdfInstance:
  sdfContext:
    ipAddress: "192.0.2.42"
    $comment: Could the constructor parameter also be considered context information..?
    temperatureUnit: Cel
~~~
{:sdf #code-sdf-construction-message
title="Example for an SDF construction message"}

## Delta Messages

TODO: Reword

When the state of a device at a given point in time is known (e.g., due to a
previous instance message), an external entity might only be interested in the
changes since that point in time. Or it might want to adjust its state and/or
context the device operates in. For both purposes, instance messages can be
used.

{{code-sdf-delta-message}} shows an example that contains an instance message
reporting a "proofshot delta", that is the state changes that occured compared
to the ones reported in the previous message (identified via its
`previousMessageId`). In this example, only the temperature as measured by the
sensor has changed, so only that information is included.

Delta messages could be used in the Series Transfer Pattern {{STP}}, which may
be one way to model a telemetry stream from a device.

~~~ sdf
info:
  title: Example SDF delta instance message
  previousMessageId: 026c1f58-7bb9-4927-81cf-1ca0c25a857b
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a42
namespace:
  cap: https://example.com/capability/cap
  models: https://example.com/models
defaultNamespace: cap
sdfInstanceOf:
  model: models:/sdfObject/envSensor
sdfInstance:
  sdfProperty:
    temperature: 24
~~~
{:sdf #code-sdf-delta-message
title="Example of an SDF instance message that serves as a delta."}

## Patch Messages

TODO: Reword

Yet another purpose for instance message might be appyling an update to a
device's configuration, e.g. via a so-called context patch message.
Such a message is shown in {{code-sdf-context-patch}}, where a change of the
device's `mountType` is reflected. This message type might be especially
relevant for digital twins {{-digital-twin}}, where changes to physical
attributes (such as the location) need to be reflected somehow.

~~~ sdf
info:
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a42
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfInstanceOf:
  model: sensors:#/sdfObject/envSensor
  patchMethod: merge-patch
sdfInstance:
  sdfContext:
    installationInfo:
      mountType: wall

~~~
{:sdf #code-sdf-context-patch
title="Example of an SDF context patch message that uses the common instance message format."}

When comparing  {{code-sdf-delta-message}} and {{code-sdf-context-patch}}, we
can see that the main difference between the messages is the _purpose_ these
message are being used for. This purpose could be implicitly reflected by the
nature of the resource that accepts or returns the respective message type.
It would also be possible to indicate the purpose more explicitly by using a
different content format when transferring the messages over the wire.
Another difference, however, lays in the fact that the context patch is not
including a `previousMessageId`, which might be sufficient to distinguish the
two message types.

Despite their different purpose, both messages will apply some kind of patch
algorithm.
JSON Merge Patch {{-merge-patch}} is probably a strong contender for the default
algorithm that will be used a little bit differently depending on the message
type (the context patch will be applied "internally" by the device, while
the delta message will be processed together with its predecessor by a
consumer). As there might be cases where the Merge Patch algorithm is not
sufficient, different algorithms (that can be IANA registered) are going to be
settable via the `patchMethod` field within the `sdfInstanceOf` quality.

## Identity Manifest

TODO

# Examples for SDF Constructors

TODO: This section needs to be updated/reworked

{{code-sdf-constructor-action}} shows a potential approach for describing
constructors via the `sdfAction` keyword with a set of construction parameters
contained in its `sdfInputData`.

As the constructor action is modeled as being detached from the device and
performed by an external `constructor` in this example, both the resulting model
and the initial instance description (which can be considered an identity
manifest) are returned.
The schema information that governs the shape of both the model and the instance
message are referred to via the `sdfRef` keyword.

DISCUSS: Note that the action may also return a pointer to an external SDF model
and provide the additional information from the constructor via an SDF Mapping
File. These are aspects that still require discussion, examples, and
implementation experience.

~~~ sdf
info:
  title: Example document for SDF with actions as constructors for instantiation
  version: '2019-04-24'
  copyright: Copyright 2019 Example Corp. All rights reserved.
  license: https://example.com/license
namespace:
  sdf: https://example.com/common/sdf/definitions
  cap: https://example.com/capability/cap
defaultNamespace: cap
sdfObject:
  constructor:
    sdfAction:
      construct:
        sdfInputData:
          "$comment": "DISCUSS: Do we need to establish a connection between constructor parameters and the resulting instance message?"
          type: object
          properties:
            temperatureUnit:
              type: string
            ipAddress:
              type: string
          required:
            - temperatureUnit
        sdfOutputData:
          "$comment": Would we point to the JSON Schema definitions here?
          type: object
          properties:
            model:
              type: object
              properties:
                sdfRef: "sdf:#/sdf/model/format"
            instance:
              type: object
              properties:
                sdfRef: "sdf:#/instance/message/format"
~~~
{:sdf #code-sdf-constructor-action
title="Example for SDF model with constructors"}

# Discussion

(TODO)

# Security Considerations

- Pieces of instance-related information might only be available in certain scopes, e.g. certain security-related configuration parameters

(TODO)


# IANA Considerations

(TODO)

--- back


# Example SDF Model

{{code-off-device-model}} shows the model all of the examples for instance-related messages are pointing to in this document.
Note how the namespace is managed here to export the `envSensor` component into
`models:#/sdfObject/envSensor`, which is the "entry point" used in the instance
messages within the main document.

~~~ sdf
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensors
defaultNamespace: models
sdfObject:
  envSensor:
    sdfContext:
      timestamp:
        type: string
      thingId:
        type: string
      deviceIdentity:
        manufacturer:
          type: string
        firmwareVersion:
          type: string
      installationInfo:
        type: object
        properties:
          floor:
            type: integer
          mountType:
            enum:
            - ceiling
            - wall
    sdfProperty:
      temperature:
        type: number
        unit: Cel

~~~
{:sdf #code-off-device-model
title="SDF Model that serves as a reference point for the instance messages in this draft"}

# Formal Syntax of Instance-related Messages {#syntax}

~~~ cddl
{::include sdf-instance-messages.cddl}
~~~

# Roads Not Taken

This appendix documents previous modelling approaches that we eventually
decided against pursuing further.
Its main purpose is to illustrate our development process, showing
which kind of alternatives we considered before choosing a particular way
to describe instance information.
We will remove this appendix as soon as this document is about to be finished.

## Using SDF Models as Proofshots

As shown in {{code-instance-syntactic-sugar-illustration}},
the proofshot format could have also been modeled via SDF models where
all `sdfProperty` definitions are given `const`values.
However, this concept is not capable of capturing actions and events.

~~~ sdf
info:
  title: "An example model of the heater #1 in the boat #007 (that resembles a proofshot)"
  version: '2025-07-15'
  copyright: Copyright 2025. All rights reserved.
namespace:
  models: https://example.com/models
defaultNamespace: models
sdfThing:
  boat007:
    label: "Digital Twin of Boat #007"
    description: A ship equipped with heating and navigation systems
    sdfContext:
      scimObjectId:
        type: string
      identifier:
        type: string
        const: urn:boat:007:heater:1
      location:
        type: object
        const:
          wgs84:
            latitude: 35.2988233791372
            longitude: 129.25478376484912
            altitude: 0.0
          postal:
            city: Ulsan
            post-code: '44110'
            country: South Korea
          w3w:
            what3words: toggle.mopped.garages
      owner:
        type: string
        default: ExamTech Ltd.
        const: ExamTech Ltd.
    sdfRequired: "#/sdfThing/boat007/sdfObject/heater1"
    sdfObject:
      heater:
        label: Cabin Heater
        description: Temperature control system for cabin heating
        sdfProperty:
          characteristic:
            description: Technical summary of the heater
            type: string
            default: 12V electric heater, 800W, automatic cutoff
            const: 12V electric heater, 800W, automatic cutoff
          status:
            description: Current operational status
            type: string
            enum:
              - on
              - off
              - error
            default: off
            const: off
          report:
            type: string
            const: 'On February 24, 2025, the boat #007''s heater #1 was on from 9 a.m. to 6 p.m.'
        sdfEvent:
          overheating:
            "$comment": Note that it is unclear how to properly model events or event history with the approach illustrated by this example.
            maintenanceSchedule: "Next scheduled maintenance date"
            sdfOutputData:
              type: string
              format: date-time
              const: '2025-07-15T07:27:15+0000'
~~~
{:sdf #code-instance-syntactic-sugar-illustration
title="SDF instance proposal for Figure 2 in [I-D.lee-asdf-digital-twin-09]"}

### Alternative Instance Keys

Below you can see an alternative instance modelling approach with IDs as (part of the) instance keys.

~~~ sdf
info:
  title: 'A proofshot example for heater #1 on boat #007'
  version: '2025-07-15'
  copyright: Copyright 2025. All rights reserved.
  proofshotId: 026c1f58-7bb9-4927-81cf-1ca0c25a857b
namespace:
  models: https://example.com/models
  boats: https://example.com/boats
defaultNamespace: boats
sdfInstance:
  models:#/sdfThing/boat/007:
    sdfInstanceOf: models:#/sdfThing/boat
    heater: models:#/sdfThing/boat/sdfObject/heater/001
    scimObjectId: a2e06d16-df2c-4618-aacd-490985a3f763
    identifier: urn:boat:007:heater:1
    location:
      wgs84:
        latitude: 35.2988233791372
        longitude: 129.25478376484912
        altitude: 0
      postal:
        city: Ulsan
        post-code: '44110'
        country: South Korea
      w3w:
        what3words: toggle.mopped.garages
    owner: ExamTech Ltd.
  models:#/sdfThing/boat/sdfObject/heater/001:
    characteristic: 12V electric heater, 800W, automatic cutoff
    status: error
    report: 'On February 24, 2025, the boat #007''s heater #1 was on from 9
      a.m. to 6 p.m.'
    sdfEvent:
      maintenanceSchedule:
      - outputValue: '2025-04-10'
        timestamp: '2024-04-10T02:00:00Z'
      - outputValue: '2026-04-10'
        timestamp: '2025-04-10T02:00:00Z'
~~~
{:sdf #code-off-device-instance-alternative
title="SDF instance proposal (with IDs as part of the instance keys) for Figure 2 in [I-D.lee-asdf-digital-twin-09]"}

{::include-all lists.md}


# Acknowledgments
{:unnumbered}

(TODO)
