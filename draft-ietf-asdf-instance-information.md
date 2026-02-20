---
v: 3

title: Instance Information for SDF
abbrev: SDF Instance Information
category: std
stream: IETF
consensus: true

docname: draft-ietf-asdf-instance-information-latest
number:
date:
area: "Applications and Real-Time"
workgroup: ASDF
keyword:
 - IoT
 - Link
 - Information Model
 - Interaction Model
 - Data Model
venue:
  group: "\"A Semantic Definition Format for Data and Interactions of Things\" (ASDF)"
  mail: "asdf@ietf.org"
  github: "ietf-wg-asdf/instance-information"

author:
- name: Jan Romann
  org: Universität Bremen
  email: jan.romann@uni-bremen.de
  country: Germany
- name: Carsten Bormann
  org: Universität Bremen TZI
  street: Postfach 330440
  city: Bremen
  code: D-28359
  country: Germany
  phone: +49-421-218-63921
  email: cabo@tzi.org

normative:
  RFC9880: sdf
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
  I-D.ietf-asdf-digital-twin: digital-twin
  LAYERS:
    target: https://github.com/t2trg/wishi/wiki/NOTE:-Terminology-for-Layers
    title: Terminology for Layers
    rc: WISHI Wiki
    date: false
  STP: I-D.bormann-t2trg-stp
  RFC9039: device-id
  I-D.ietf-asdf-sdf-protocol-mapping: protocol-map
...

--- abstract

This document specifies instance-related messages to be used in conjunction with the Semantic Definition Format (SDF) for Data and Interactions of Things (RFC 9880).
Split into four "archetypes", instance-related messages are always governed by SDF models, strictly separating instance and class information.
*Context* information plays a crucial role both for lifecycle management and actual device interaction.

[^status]

[^status]: This revision updates the base SDF reference to the recently published RFC 9880, improves the terminology section, and applies a bug fix to an example.

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

SDF does not define representation formats for the *Instance Information* that is
exchanged in, or the subject of such, interactions; this is left to the
specific ecosystems, which tend to have rather different ways to
represent this information.

This document discusses Instance Information in different types and roles.
It defines an *abstraction* of this, as an eco-system independent way to reason about this information.
This abstraction can be used at a *conceptual* level, e.g., to define models that govern the instance information.
However, where this is desired, it also can be used as the basis for a concrete *neutral representation* (Format) that can actually be used for interchange to exchange information and parameters for interactions to be performed.
In either case, the structure and semantics of this information are governed by SDF Models.

This document is truly work in progress.
It freely copies examples from the {{-non-affordance}} document that evolves in
parallel, with a goal of further synchronizing the development where that
hasn't been fully achieved yet.
After the discussion stabilizes, we'll need to discuss how the
information should be distributed into the different documents and/or
how documents should be merged.

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
  aided by *mapping files* {{-mapping}} that apply to the SDF model
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

Instance-related Message:
: A message that describes the state or a state change of a specific instance.
  (TBC -- also: do we need this additional term?)

Message Archetype:
: In the context of instance-related messages:
  A message with specific content and effect, covering a wider set of different use cases.
  In this document, we are observing a total of four instance-related message archetypes:
  Snapshot Messages, Construction Messages, Delta Messages, and Patch Messages.

Snapshot:
: A message that attempts to describe the state of an Instance at a
  particular moment (which may be part of the context).
  This state information may either be related to interaction affordances
  or to the Thing's context.

  When a Snapshot message contains affordance-related information,
  it may be considered a "proofshot" -- they are "proofs" in the
  photographic sense, i.e., they may not be of perfect quality, as
  inaccuracies could occur while capturing the affordance state.

  Conversely, Snapshot messages that (only) contain context information
  may be referred to as "Context Snapshots".

  Not all state that is characteristic of an Instance may be included
  in a Snapshot (e.g., information about an active action that is not
  embedded in an action resource).
  Snapshots may depend on additional context (such as the identity of
  the Instance and a Timestamp).

  An interaction affordance to obtain a Snapshot may not be provided
  by every Instance; instead, the affordance may be "baked into" the
  device and could be discoverable via a well-known URI.

Delta:
: Delta messages are syntactically similar to Snapshots, but may be
  used to only report information that has _changed_ compared to a
  given reference Snapshot or Delta message.

Construction:
: Construction messages enable the creation of a digital Instance,
  e.g., initialization/commissioning of a device or creation of its
  digital twins.
  They are like Snapshots, in that they embody a state, however this
  state needs to be precise so the construction can actually happen.

Patch:
: Patch messages update the otherwise immutable state of a device or its
  digital twin by triggering a reconfiguration or recommisioning.
  Similar to Delta messages, Patch messages are referring to an already
  existing state that is altered in accordance with the information
  contained within the message.

{::boilerplate bcp14-tagged-bcp14}

# Instance Information and SDF

The instantiation of an SDF model does not directly express an instance, which is, for example, a physical device or a digital twin.
Instead, the instantiation produces an instance-related *message*, which adheres to a uniform message format and is always controlled by the corresponding SDF model.
Depending on the recipient and its purpose, a message can be interpreted as a report regarding the state of a Thing or the instruction to change it when consumed by the recipient.

Taking into account previous revisions of this document as well as {{-non-affordance}}, we identified two main dimensions for covering the potential use cases for instance-related messages:

1. the intended effect of a message, which can either be a report or an update of a Thing's state, and
2. the actual content of the message, which may be freestanding (without a reference to a previous message or state) or relative (with such a reference).

Based on these considerations (as illustrated by the systematization in {{instance-message-dimensions}}), we can identify the following four message archetypes:

1. *Snapshot* messages that may contain contain both affordance-related and context information, including information about a Thing's identity,
2. *Construction* messages that trigger a Thing's initial configuration process or its commissioning,
3. *Delta* messages that indicate changes that have occurred since a reference state report, and
4. *Patch* messages that update the Thing's state.

<table>
  <thead>
    <tr>
      <!-- FIXME: This does not work with kramdown-rfc at the moment -->
      <!-- <th colspan="2" rowspan="2"></th> -->

      <th colspan="2"></th>
      <th colspan="2" align="center">Content</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th colspan="2"></th>
      <th align="center">Freestanding</th>
      <th align="center">Relative</th>
    </tr>
    <tr>
      <!-- TODO: Vertical alignment is apparently not supported at the moment -->
      <th rowspan="2" align="center">(Intended)<br>Effect</th>
      <th align="center">State Exposure</th>
      <td align="center">Snapshot</td>
      <td align="center">Delta</td>
    </tr>
    <tr>
      <th align="center">State Change</th>
      <td align="center">Construction</td>
      <td align="center">Patch</td>
    </tr>
  </tbody>
</table>
{: #instance-message-dimensions title="Systematization of instance-related messages along the dimensions \"Content\" and \"(Intended) Effect\"."}

The uniform message format can be used for all four message archetypes.
{{syntax}} specifies the formal syntax of instance-related messages that all normative statements as well as the examples in this document will adhere to.
This syntax can serve to describe both the abstract structure and the concrete shape of the messages that can be used as a neutral form in interchange.

In the following, we will first outline a number of general principles for instance-related messages, before detailing the specific archetypes we define in this document.
The specification text itself will be accompanied by examples that have been inspired by {{-non-affordance}} and {{-digital-twin}} that each correspond with one of the four archetypes.

## Axioms for instance-related messages

<!-- TODO: Integrate this into the document in a better way -->

Instance-related messages can be messages that relate to a property, action, or
event (input or output data), or they can be "proofshots" (extracted state
information, either in general or in a specific form such as a context snapshot etc.).

Instance-related messages are controlled by a *model* (class-level information),
which normally is the interaction model of the device.
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

## Context Information

Messages always have context, typically describing the "me" and the
"you" of the interaction, the "now" and "here", allowing deictic
statements such as "the temperature here" or "my current draw".

Messages may have to be complemented by this context for
interpretation, i.e., the context needed may need to be reified in the
message (compare the use of SenML "n").
Information that enables interactions via application-layer protocols (such as an IP address) can also be considered context information.
For this purpose, the `sdfProperty` quality is reused.

TODO: explain how {{RFC9039}} could be used to obtain device names (using `urn:dev:org` in the example).

Note that one interesting piece of context information is the model itself, including the information block and the default namespace.
This is of course not about the device or its twin (or even its asset management), because models and devices may want to associate freely.
Also note that multiple models may apply to the same device (including but not only revisions of the same models).

# Message Format {#message-format}

The data model of instance-related messages makes use of the structural features of SDF models (e.g., when it comes to metadata and namespace information), but is also different in crucial aspects.

## Information Block

The information block contains the same qualities as an SDF model and, additionally, a mandatory `messageId` to uniquely identify the message.
Furthermore, Delta messages can utilize the `previousMessageId` in order to link two messages and indicate the state change.

| Quality            | Type             | Description                                                                |
|--------------------|------------------|----------------------------------------------------------------------------|
| title              | string           | A short summary to be displayed in search results, etc.                    |
| description        | string           | Long-form text description (no constraints)                                |
| version            | string           | The incremental version of the definition                                  |
| modified           | string           | Time of the latest modification                                            |
| copyright          | string           | Link to text or embedded text containing a copyright notice                |
| license            | string           | Link to text or embedded text containing license terms                     |
| messageId          | string           | Unique identifier of this instance-related message                         |
| previousMessageId  | string           | Identifier used to connect this instance-related message to a previous one |
| timestamp          | string           | Indicates the point in time this instance-related message refers to        |
| features           | array of strings | List of extension features used                                            |
| $comment           | string           | Source code comments only, no semantics                                    |
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

Distinct from SDF models are two instance-specific blocks, the first of which is identified via the `sdfInstanceOf` keyword.
Via the `model` keyword, this quality defines the entry point the `sdfInstance` quality from the next section is referring to.
Furthermore, via the `patchMethod` field, a patch algorithm different from JSON Merge Patch can be specified.

| Quality          | Type   | Description                                                                                                                                                    |
|------------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| model            | string | Defines the entry point for `sdfInstance` by pointing to an `sdfObject` or an `sdfThing`. Has to be based on a namespace identifier from the `namespaces` map. |
| patchMethod      | string | Allows for overriding the default patch method (JSON Merge Patch) by providing a registered value.                                                             |
| $comment         | string | Source code comments only, no semantics                                                                                                                        |
{: #iobsec title="Instance-of Block"}

## Instance Block

In the instance block, state information for properties, actions, and events as well as context information can be included.
Depending on the archetype, this information will either be used to report a Thing's current state, to report state *changes*, or to update state via a patch or reconfiguration.

In addition to the `messageId` and `previousMessageId` from the `info` block, we are able to refer to

* the point in time when the information regarding the device state has been captured (via the `timestamp` quality) and
* the device identity (via the `thingId` qualitity in the `sdfInstance` block).

Since we are using the `sdfInstance` keyword as an entry point at the location pointed to via the `model` specfied in `sdfInstanceOf`, the instance-related message has to follow the structure of this part of the model (although, depending on the archetype, information that has not changed or will not be updated can be left out.)

The alternating structure of the SDF model (e. g., `sdfObject/envSensor/sdfProperty/temperature`) is repeated within the instance-related message, with the top-level `sdfObject` or `sdfThing` being replaced by `sdfInstance` at the entry point.
Note that we also have to replicate a nested structure via `sdfThing` and/or `sdfObject` if present in the referenced SDF model.

<!-- TODO: The descriptions need some refinement here. Also: Maybe we need to specify the shape of the qualities in addional sections -->

| Quality          | Type   | Description                                                         |
|------------------|--------|-------------------------------------------------------------------- |
| thingId          | string | (Optional) identifier of the instance (e.g., a UUID)                |
| sdfThing         | map    | Values for the thing entries in the referenced SDF definition       |
| sdfObject        | map    | Values for the object entries in the referenced SDF definition      |
| sdfProperty      | map    | Values for the properties in the referenced SDF definition          |
| sdfAction        | map    | Values for the actions in the referenced SDF definition             |
| sdfEvent         | map    | Values for the events in the referenced SDF definition              |
{: #ibsec title="Instance Block"}

# Message Archetypes

Based on the common message format defined in {{message-format}} and the systematization from {{instance-message-dimensions}}, we can derive a set of four archetypes that serve different use cases and recipients.

TODO: Decide whether we want to add specific CDDL schemas for the four archetypes via extension points in the "base schema"

## Snapshot Messages

This instance-related message contains information on a Thing's state, both in terms of context information and the state of individual affordances.
In the message, the `previousMessageId` field in the information block MUST NOT be present.
Furthermore, when transmitting this message in its JSON format, the content type `application/sdf-snapshot+json` MUST be indicated if supported by the protocol used for transmission.

Snapshot messages MAY only contain values for a *subset* of all possible affordances and context information exposed by a Thing.
Security-related aspects, e.g. regarding authentication and authorization, MUST be taken into account when issueing a state report for a requesting party.

In practical use, we can at least differentiate two use cases for snapshot messages.
The corresponding message variants are (colloquially) referred to as "Context Snapshots" and "Proofshots".

Context Snapshots *only* contain context information related to a Thing (indicated via non-writable `sdfPropety` definitions).
{{example-context}} gives an example for this kind of instance-related message.

~~~ sdf
info:
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a42
  timestamp: '2025-07-01T12:00:00Z'
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensors
defaultNamespace: models
sdfInstanceOf:
  model: sensors:#/sdfObject/envSensor
sdfInstance:
  thingId: envSensor:abc123
  sdfProperty:
    installationInfo:
      floor: 3
      mountType: ceiling
      indoorOutdoor: indoor
~~~
{:sdf #example-context
title="Example of an SDF context snapshot."}

Proofshot Messages are supersets of context snapshots that may also include state information associated with a Thing's *interaction affordances*(properties, actions, and events).

[^other-affordances]

[^other-affordances]: Note that while the format for describing the state of properties is clearly governed by the schema information from the corresponding `sdfProperty` definition, it is still unclear how to best model the state of `sdfAction`s and `sdfEvent`s.

{{code-off-device-instance}} shows a proofshot that captures the state of a
sensor.
Here, every property and context definition of the corresponding SDF model
(see {{code-off-device-model}}) is mapped to a concrete value that satisfies
the associated schema.

~~~ sdf
info:
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a42
  timestamp: '2025-07-01T12:00:00Z'
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfInstanceOf:
  model: sensors:#/sdfObject/envSensor
sdfInstance:
  thingId: envSensor:abc123
  sdfProperty:
    installationInfo:
      mountType: ceiling
    temperature: 23.124

~~~
{:sdf #code-off-device-instance post="fold"
title="SDF proofshot example."}

## Construction Messages

Construction messages are structurally equivalent to snapshot messages but may only contain context information.
Furthermore, the recipient of a construction message is supposed to initiate a configuration or comissioning process upon recption.
Construction messages MUST be indicated by the media type `application/sfd-construction+json` if possible.

A construction message for a temperature sensor might assign an identity and/or complement it by temporary identity information (e.g., an IP address);
its processing might also generate construction output (e.g., a public key or an IP address if those are generated on device) which can be described via instance-related messages such as snapshot messages.

The creation of construction messages is linked to the invocation of a constructor that starts the actual construction process.
In practice, these constructors are going to be modeled as an `sdfAction`, although the way the `sdfAction` is going to be used exactly is not entirely clear yet.

<!-- TODO: Maybe this note could also be removed -->
[^note-destructor]

[^note-destructor]: Note that it is not quite clear what a destructor would be for a physical instance -- apart from a scrap metal press, but according to RFC 8576 we would want to move a system to a re-usable initial state, which is pretty much a constructor.

{{code-sdf-construction-message}} shows a potential SDF construction message that initializes a device, setting its `manufacturer` and `firmwareVersion` as context information.
The construction message also assigns a `thingId`, the `unit` of reported temperature values, and an initial `ipAddress` that can be used with the interaction affordances that may be present in the corresponding SDF model.

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
  thingId: envSensor:unit42
  sdfProperty:
    ipAddress: 192.168.1.5
    unit: Cel
    deviceIdentity:
      manufacturer: HealthTech Inc.
      firmwareVersion: 1.4.3
~~~
{:sdf #code-sdf-construction-message
title="Example for an SDF construction message"}

A special type of construction message that only contains identity-related information may be called an *Identity Manifest*.
{{code-sdf-identity-manifest}} shows an example of an identity manifest that is structurally identical to the construction message from {{code-sdf-construction-message}}, with the non-identity-related information left out.

<!-- TODO: Evaluate whether this approach actually works -->
Via `sdfRequired`, an SDF model can indicate which context information must be present and therefore initialized within an instance.
All definitions included in `sdfRequired` MUST also be present in a construction message, while definitions could be left out.

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
  thingId: envSensor:unit42
  sdfProperty:
    deviceIdentity:
      manufacturer: HealthTech Inc.
      firmwareVersion: 1.4.3
~~~
{:sdf #code-sdf-identity-manifest
title="Example of an SDF identity manifest"}

## Delta Messages

Delta messages describe updates to a Thing's state relative to a previous message.
For this purpose, a `previousMessageId` MUST be present in the info block.
When transmitting delta messages, the media type `application/sdf-delta+json` MUST be used if possible.

By default, the values contained in the message are applied to the preceding message(s) via the JSON Merge Patch algorithm.
Via the `patchMethod` quality, different patch algorithms MAY be indicated.

{{code-sdf-delta-message}} shows an example Delta message that reports state changes compared to the ones reported in the previous message (identified via its `previousMessageId`).
In this example, only the temperature that has been measured by the sensor has changed, which is why it is the only piece of information that is included.

Delta messages could be used in the Series Transfer Pattern {{STP}}, which may be one way to model a telemetry stream from a device.

~~~ sdf
info:
  title: Example SDF delta message
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
title="Example of an SDF instance-related message that serves as a delta."}

## Patch Messages

Patch messages are structurally equivalent to delta messages, but once again are only allowed to contain context information.
They utilize a patch *mechanism* (which may be explicitly indicated via the `patchMethod` quality) to *alter* the state of a Thing instead of *reporting* state changes.
Since patch messages are not referring to a preceding message, a `previosMessageId` MUST NOT be present in the information block.
When transmitting state patches, the media type `application/sdf-patch+json` MUST be used if possible.

An example Patch Message is shown in {{code-sdf-context-patch}}, where a change of the device's `mountType` is signalled.

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
  sdfProperty:
    installationInfo:
      mountType: wall
~~~
{:sdf #code-sdf-context-patch
title="Example of an SDF context patch message that uses the common instance-related message format."}

Practical uses for patch message include digital twins {{-digital-twin}}, where changes to physical attributes (such as the location) need to be reflected in the digital representation of a Thing.

# Application Scenarios

The instance-related message format and the four architectures are usable in a number of use cases, some of which we are going to specify in the following.
Other specifications may define additional use cases instance-related messages can be used for.

## Construction

In SDF models, we can specify a Thing's configurable parameters via `sdfProperty` definitions for which Construction Messages can provide concrete values.
{{code-sdf-construction-sdf-context}} shows an example for such an SDF model.
In this example, the `unit` quality of the `temperature` property has to be considered a construction parameter, as a connection to the `unit` property is established via the `sdfParameters` map using a JSON Pointer.

If the `unit` is not initialized during construction, it falls back to the default `Cel` for degrees Celcius.

~~~ sdf
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfObject:
  sensor:
    sdfRequired:
      - ipAddress
      - deviceIdentity
    sdfProperty:
      ipAddress:
        writable: false
        type: string
      unit:
        writable: false
        type: string
        default: Cel
      deviceIdentity:
        writable: false
        type: object
        properties:
          manufacturer:
            type: string
          firmwareVersion:
            type: string
      temperature:
        type: number
        sdfParameters:
          unit: "#/sdfObject/sensor/sdfProperty/unit"
~~~
{:sdf #code-sdf-construction-sdf-context
title="Example for SDF model with constructors"}

Based on the SDF model above, a Construction Message such as the one shown in {{code-sdf-construction-message}} can trigger a construction process.
As indicated via `sdfRequired`, this process must include the initialization of an IP address as well as the device's identity definitions.
Initializing the `unit` quality is only required if the `temperature` property is present, which is expressed by the JSON pointer within the property's `sdfRequired` definition.

## Protocol Binding Information

When using the `sdfProtocolMap` concept introduced in {{-protocol-map}}, some protocols may need context information such as a hostname or an IP address to actually be usable for interactions.
This corresponds with the fact that the parameters related to application-layer protocols are often _class-level_ information and therefore not necessarily instance-specific.

For example, all instances of a smart light may use similar CoAP resources, with the only difference being the concrete IP address assigned to them.
Therefore, we can utilize context information that varies between instances to complement the model information provided via an `sdfProtocolMap`.

{{code-sdf-protocol-map-plus-context}} illustrates the potential relationship between the two concepts in an SDF model.
Here, a (hypothetical) CoAP protocol mapping specification defines an interface for parameters such as an IP address.
Via JSON pointers, the `sdfParameters` within the `sdfProtocolMap` are linked to compatible `sdfProperty` definitions that may further restrict the set of allowed values via their schema.

~~~ sdf
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfObject:
  sensor:
    sdfRequired:
      - ipAddress
    sdfProperty:
      ipAddress:
        writable: false
        type: string
      temperature:
        type: number
        sdfProtocolMap:
          coap:
            sdfParameters:
              ipAddress: "#/sdfObject/sensor/sdfProperty/ipAddress"
            read:
              method: GET
              href: "/temperature"
              contentType: 60
~~~
{:sdf #code-sdf-protocol-map-plus-context
title="Example of an SDF model where a CoAP-based protocol map points to the definition of relevant context information: an IP address."}

{{code-sdf-ipaddress-context}} shows how a Snapshot Message can report the necessary IP address that is needed for retrieving the temperature value from the sensor described by the SDF model above.

~~~ sdf
info:
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a47
namespace:
  models: https://example.com/models
  sensors: https://example.com/sensor
defaultNamespace: models
sdfInstanceOf:
  model: sensors:#/sdfObject/sensor
sdfInstance:
  sdfProperty:
    ipAddress: 192.168.1.5
~~~
{:sdf #code-sdf-ipaddress-context
title="Example of a snapshot message that provides the IP address needed to perform a CoAP-based interaction with the sensor from the previous figure."}

## Modelling the State of Interaction Affordances

Snapshot and (in a relative fashion) Delta Messages can report the current state associated with interaction affordances.
For `sdfProperty` definitions, this is very straightforward, as previously seen in in {{code-sdf-delta-message}}.

Actions and events, however, need to be handled differently: In the case of actions, the state of one or more actions is reported, which might already be in a completed or error state, or may also still be running.
For events, a history is reported that includes the returned values.
The exact of number of action and event reports is implementation-dependent and may vary between deployments.

{{code-snapshot-with-actions-and-events}} shows an example of a Snapshot Message for a lightswitch which reports the results of two `toggle` actions, one of which failed.
The successfully completed action caused the emission of a `toggleEvent` with the same `timestamp`.
As the lightswitch was turned on, the event was emitted with a value of `true`.

~~~ sdf
info:
  title: Example SDF Snapshot Message with an Action and an Event History.
  messageId: 75532020-8f64-4daf-a241-fcb0b6dc4a85
namespace:
  cap: https://example.com/capability/cap
  models: https://example.com/models
defaultNamespace: cap
sdfInstanceOf:
  model: models:/sdfObject/lightSwitch
sdfInstance:
  sdfAction:
    toggle:
    - timestamp: "2026-01-11T22:39:35.000Z"
      status: complete
      inputValue:
      outputValue:
    - timestamp: "2026-01-11T22:34:35.000Z"
      status: error
      inputValue:
      outputValue: Toggle failed.
      "$comment": This action completed with an error, which is why an error message was returned.
  sdfEvent:
    toggleEvent:
    - timestamp: "2026-01-11T22:39:35.000Z"
      outputValue: true
~~~
{:sdf #code-snapshot-with-actions-and-events
title="Example of an SDF Snapshot Messages that reports an action and an event history."}

# Discussion

(TODO)

Discuss Proofshots of a Thing (device) and of other components.

Discuss concurrency problems with getting and setting Proofshots.

Discuss Timestamps appropriate for Things ({{Section 4.4 of -terms}}, {{-raytime}}).

Discuss YANG config=true approach with regard to construction messages.

Discuss expressing a device's "purpose of life" via context information

Discuss using context information to indicate provence

# Security Considerations

- Pieces of instance-related information might only be available in certain scopes, e.g. certain security-related configuration parameters

(TODO)


# IANA Considerations

TODO: Add media type registrations

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
    sdfProperty:
      deviceIdentity:
        writable: false
        type: object
        properties:
          manufacturer:
            type: string
          firmwareVersion:
            type: string
      installationInfo:
        writable: false
        type: object
        properties:
          floor:
            type: integer
          mountType:
            enum:
            - ceiling
            - wall
      temperature:
        type: number
        unit: Cel
~~~
{:sdf #code-off-device-model
title="SDF Model that serves as a reference point for the instance-related messages in this draft"}

# Formal Syntax of Instance-related Messages {#syntax}

~~~ cddl
{::include sdf-instance-messages.cddl}
~~~

{::include-all lists.md}


# Acknowledgments
{:unnumbered}

(TODO)
