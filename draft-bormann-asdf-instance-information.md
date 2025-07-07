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
  # I-D.laari-asdf-relations: sdfrel
  # I-D.bormann-asdf-sdftype-link: sdflink
  I-D.bormann-asdf-sdf-mapping: mapping
  # RFC9423: attr
  I-D.ietf-iotops-7228bis: terms
  I-D.amsuess-t2trg-raytime: raytime
  I-D.lee-asdf-digital-twin-07: digital-twin-old
  I-D.lee-asdf-digital-twin-08: digital-twin
  LAYERS:
    target: https://github.com/t2trg/wishi/wiki/NOTE:-Terminology-for-Layers
    title: Terminology for Layers
    rc: WISHI Wiki
    date: false
  STP: I-D.bormann-t2trg-stp
  RFC9039: device-id

--- abstract

This document discusses types of Instance Information to be used in
conjunction with the Semantic Definition Format (SDF) for Data and
Interactions of Things (draft-ietf-asdf-sdf) and will ultimately
define Representation Formats for them as well as ways to use SDF
Models to describe them.

[^status]

[^status]: The present revision –01 has been slightly updated from the
    discussion at the 2025-04-09 ASDF meeting.


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

# Instance Information and SDF

Instantiation doesn't produce an instance (ouch), which is the device,
twin, etc., but a message.

## Pre-structured types of messages

Pre-structured types of messages are those that relate to an SDF model
in a way that, together with context and model, they are fully
self-describing.

### Input and output data of specific interactions

Messages always have context, typically describing the "me" and the
"you" of the interaction, the "now" and "here", allowing deictic
statements ("the temperature here", "my current draw")...

Messages may have to be complemented by this context for
interpretation, i.e., the context needed may need to be reified in the
message (compare the use of SenML "n").

TODO: Use NIPC as an example how this could be used, including SCIM as
a source of context information.

TODO: explain how {{RFC9039}} could be used to obtain device names (using `urn:dev:org` in the example).

(Describe how protocol bindings can be used to convert these messages
to/from concrete serializations...)

#### Examples for context information

~~~ json-from-yaml
namespace:
  models: https://example.com/models
  boats: https://example.com/boats
defaultNamespace: boats
sdfInstance:
  "$context":
    "$comment": Potential contents for the SDF context
    deviceName: urn:dev:org:30810-boat007
    deviceEui64Address: 50:32:5F:FF:FE:E7:67:28
    scimObjectId: 8988be82-50dc-4249-bed2-60c9c8797677
    parentInstance: TODO -- addressing instance in data tree
~~~
{: #example-context post="fold"
title="Example for an SDF instance with context information"}

### Proofshots (read device, other component)

(See defn above.)

The following examples are based on Figure 2 of {{-digital-twin}}, separated into
an SDF proofshot and an SDF model.

A proofshot that captures the state of a boat with a heater is shown in
{{code-off-device-instance}}.
Here, every property of the corresponding SDF model (see {{code-off-device-model}})
is mapped to a concrete value that corresponds with the associated schema information.
The alternating structure of the SDF model
(e. g., `sdfThing/boot007/sdfObject/heater/sdfProperty/isHeating`) is repeated
in the proofshot, with `sdfObject` and `sdfThing` being replaced by `sdfInstance`.

While earlier approaches avoided the additional level of nesting by omitting the
affordance quality names (i.e., `sdfProperty`, `sdfAction`, `sdfEvent`),
including them explicitly avoids problems with namespace clashes and
allows for a cleaner integration of meta data (via the `$context` keyword).

As in any instance message, information from the model is not repeated but
referenced via a pointer into the model tree (`sdfInstanceOf`); the
namespace needed for this is set up in the usual `namespace` section that we
also have in model files.

Note that in this example, the proofshot also contains values for the implicit
(`offDevice`) properties that are static (e.g., the physical location assigned
to the instance) but are still part of the instance's proofshot as its location
is fixed -- this boat apparently never leaves the harbor.

~~~ json-from-yaml
info:
  title: 'A proofshot example for heater #1 on boat #007'
  version: '2025-04-08'
  copyright: Copyright 2025. All rights reserved.
namespace:
  models: https://example.com/models
  boats: https://example.com/boats
defaultNamespace: boats
sdfInstance:
  boat007:
    sdfInstanceOf: models:#/sdfThing/boat
    "$comment": Should the context be modeled via an additional quality? Or should
      it rather become another kind of property?
    "$context": # DISCUSS: We could also remove the leading "$" of the context
      scimObjectId: a2e06d16-df2c-4618-aacd-490985a3f763
    sdfProperty:
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
    sdfInstance:
      heater:
        sdfInstanceOf: models:#/sdfThing/boat/sdfObject/heater
        sdfProperty:
          characteristic: 12V electric heater, 800W, automatic cutoff
          status: error
          report: 'On February 24, 2025, the boat #007''s heater #1 was on from 9
            a.m. to 6 p.m.'
        sdfEvent:
          # Not a great event example IMHO... but this currently models an event history
          maintenanceSchedule:
          - outputValue: '2025-04-10'
            timestamp: '2024-04-10T02:00:00Z'
          - outputValue: '2026-04-10'
            timestamp: '2025-04-10T02:00:00Z'
~~~
{: #code-off-device-instance post="fold"
title="SDF instance proposal for Figure 2 in [I-D.lee-asdf-digital-twin-08]"}

#### Corresponding SDF Model

{{code-off-device-model}} shows a model like the one that could have
been pointed to by the `sdfInstanceOf` pointers in the instance message.
Note how the namespace is managed here to export the model components into
`models:#/sdfThing/boat` and `models:#/sdfThing/boat/sdfObject/heater`.

(This example model only specifies structure; it also could come with
semantic information such as the units that are used for wgs84 etc.
In practice, the definition of `wgs84` etc. probably would come from a common
library and just be referenced via `sdfRef`.)

~~~ json-from-yaml
info:
  title: An example model of a heater on a boat
  version: '2025-01-27'
  copyright: Copyright 2025. All rights reserved.
namespace:
  models: https://example.com/models
defaultNamespace: models
sdfThing:
  boat:
    description: A boat equipped with heating and navigation systems
    sdfProperty:
      identifier:
        "$comment": Is this actually off-device?
        type: string
        offdevice: true
      owner:
        "$comment": Is this actually off-device?
        type: string
        offdevice: true
      location:
        offdevice: true
        type: object
        properties:
          wgs84:
            type: object
            properties:
              latitude:
                type: number
              longitude:
                type: number
              altitude:
                type: number
          postal:
            type: object
            properties:
              city:
                type: string
              post-code:
                type: string
              country:
                type: string
          w3w:
            type: object
            properties:
              what3words:
                type: string
                format: "..."
    sdfObject:
      heater:
        label: Cabin Heater
        description: Temperature control system for cabin heating
        sdfProperty:
          characteristic:
            description: Technical summary of the heater
            type: string
            default: 12V electric heater, 800W, automatic cutoff
          status:
            description: Current operational status
            type: string
            enum:
            - 'on'
            - 'off'
            - error
            default: 'off'
          report:
            type: string
        sdfEvent:
          maintenanceSchedule:
            "$comment": Should this actually be modeled as an event..?
            description: Next scheduled maintenance date
            sdfOutputData:
              type: string
              format: date-time
~~~
{: #code-off-device-model post="fold"
title="Revised SDF model proposal for Figure 2 of [I-D.lee-asdf-digital-twin-08]"}

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

#### Examples

##### Example for an SDF model with constructors

~~~ json-from-yaml
info:
  title: Example document for SDF (Semantic Definition Format) with constructors for
    instantiation
  version: '2019-04-24'
  copyright: Copyright 2019 Example Corp. All rights reserved.
  license: https://example.com/license
namespace:
  cap: https://example.com/capability/cap
defaultNamespace: cap
sdfObject:
  temperatureSensor:
    sdfProperty:
      temperature:
        description: Temperature value measure by this Thing's temperature sensor.
        type: number
        sdfParameters:
        - minimum
        - targetQuality: minimum
          parameterName: minimum
          constructorName: construct
        - maximum
        - targetQuality: unit
          parameterName: "#/sdfObject/Switch/sdfConstructors/construct/temperatureUnit"
    sdfConstructors:
      "$comment": 'TODO: Dicuss whether this should be assumed to be the default constructor'
      construct:
        parameters:
          minimum:
            required: true
          maximum:
            required: false
            "$comment": Constructors could allow for further restricting values that
              can be assigned to affordances
            type: integer
          temperatureUnit:
            required: false
~~~
{: #code-sdf-constructors post="fold"
title="Example for SDF model with constructors"}

##### Example for an SDF construction message

~~~ json-from-yaml
info:
  title: Example SDF construction message
  "$comment": 'TODO: What kind of metadata do we need here?'
namespace:
  cap: https://example.com/capability/cap
defaultNamespace: cap
sdfConstruction:
  sdfConstructor: cap:#/sdfObject/temperatureSensor/sdfConstructors/construct
  arguments:
    minimum: 42
    temperatureUnit: Cel
~~~
{: #code-sdf-construction-message post="fold"
title="Example for an SDF construction message"}

### Deltas and Default/Base messages

What changed since the last proofshot?

What is different from the base status of the device?

Can I get the same (equivalent, not identical) coffee I just ordered but with 10 % more milk?

(Think merge-patch.)

A construction message may be a delta, or it may have parameters that
algorithmically influence the elements of state that one would find in
a proofshot.

~~~ json-from-yaml
info:
  title: Example SDF delta construction message
  "$comment": 'TODO: What kind of metadata do we need here?'
namespace:
  cap: https://example.com/capability/cap
defaultNamespace: cap
sdfConstruction:
  sdfConstructor: cap:#/sdfObject/temperatureSensor/sdfConstructors/construct
  previousProofshot: "???"
  arguments:
    currentTemperature: 24
~~~
{: #code-sdf-construction-delta-message post="fold"
title="Example for an SDF construction message for proofshot delta"}

Deltas and Default/Base messages could be used in the Series Transfer
Pattern {{STP}}, which may be one way to model a telemetry stream from a
device.


## Metadata

One interesting piece of offDevice information is the model itself, including sdfinfo and the defaultnamespace.  This is of course not about the device or its twin (or even its asset management), because models and devices may want to associate freely.
Multiple models may apply to the same device (including but not only revisions of the models).

# Discussion

(TODO)

# Security Considerations


(TODO)


# IANA Considerations

(TODO)

--- back

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

~~~ json-from-yaml
info:
  title: An example model of a heater on a boat (that resembles a proofshot)
  version: '2025-06-06'
  copyright: Copyright 2025. All rights reserved.
namespace:
  models: https://example.com/models
defaultNamespace: models
sdfThing:
  boat:
    sdfObject:
      heater:
        sdfProperty:
          isHeating:
            description: The state of the heater on a boat; false for off and true
              for on.
            type: boolean
            const: true
          location:
            offDevice: true
            sdfRef: "#/sdfData/location"
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
          report:
            type: object
            properties:
              value:
                type: string
                const: 'On February 24, 2025, the boat #007''s heater #1 was on from 9 a.m. to 6 p.m.'
        sdfEvent:
          overheating:
            description: "This event is emitted when a critical temperature is reached"
            sdfOutputData:
              type: number
              const: 60
              description: "TODO"
sdfData:
  location:
    type: object
    properties:
      wgs84:
        type: object
        properties:
          latitude:
            type: number
          longitude:
            type: number
          altitude:
            type: number
      postal:
        type: object
        properties:
          city:
            type: string
          post-code:
            type: string
          country:
            type: string
      w3w:
        type: object
        properties:
          what3words:
            type: string
            format: "..."
~~~
{: #code-instance-syntactic-sugar-illustration post="fold"
title="SDF instance proposal for Figure 2 in [I-D.lee-asdf-digital-twin-07]"}

### Alternative Instance Keys

Below you can see an alternative instance modelling approach with IDs as (part of the) instance keys.

~~~ json-from-yaml
info:
  title: 'An example of the heater #1 in the boat #007'
  version: '2025-04-08'
  copyright: Copyright 2025. All rights reserved.
namespace:
  models: https://example.com/models
  boats: https://example.com/boats
defaultNamespace: boats
sdfInstance:
  "models:#/sdfThing/boat/007":
    heater: models:#/sdfThing/boat/sdfObject/heater/001
  "models:#/sdfThing/boat/sdfObject/heater/001":
    "$context":
      scimObjectId: a2e06d16-df2c-4618-aacd-490985a3f763
    isHeating: true
    location:
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
    report:
      value: 'On February 24, 2025, the boat #007''s heater #1 was on from 9 a.m.
        to 6 p.m.'
    sdfEvent:
      "$comment": "TODO: Discuss how to specify how many events in the history should be displayed -- could this be done via a constructor?"
      overheating:
        - outputValue: 60.0
          timestamp: "2025-04-10T08:25:43.511Z"
        - outputValue: 65.3
          timestamp: "2025-04-10T10:25:43.511Z"
~~~
{: #code-off-device-instance-alternative post="fold"
title="SDF instance proposal (with IDs as part of the instance keys) for Figure 2 in [I-D.lee-asdf-digital-twin-07]"}

# Acknowledgments
{:unnumbered}

(TODO)
