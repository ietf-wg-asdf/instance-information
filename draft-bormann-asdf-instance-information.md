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
workgroup: "A Semantic Definition Format for Data and Interactions of Things"
keyword:
 - IoT
 - Link
 - Information Model
 - Interaction Model
 - Data Model
venue:
  group: "A Semantic Definition Format for Data and Interactions of Things"
  mail: "asdf@ietf.org"
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
  I-D.lee-asdf-digital-twin-07: digital-twin
  LAYERS:
    target: https://github.com/t2trg/wishi/wiki/NOTE:-Terminology-for-Layers
    title: Terminology for Layers
    rc: WISHI Wiki
    date: false

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

Terminology may need to be imported from {{LAYERS}}.

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

#### Examples for context information

~~~ json
{
  "sdfContext": {
    "$comment": "Potential contents for the SDF context",
    "deviceName": "urn:sdf:foo:bar",
    "deviceEui64Address": "50:32:5F:FF:FE:E7:67:28",
    "scimObjectId": "8988be82-50dc-4249-bed2-60c9c8797677",
    "parentInstance": "TODO"
  },
  "namespace": {
    "models": "https://example.com/models",
    "boats": "https://example.com/boats"
  },
  "defaultNamespace": "boats",

  "sdfInstance": {

  }
}
~~~

### Proofshots (read device, other component)

(See defn above.)

A proofshot that captures the state of an instance can be modelled as shown in
{{code-non-affordance-instance}}.
Here, every property of the corresponding SDF model (see {{code-non-affordance-model}})
is mapped to a concrete value that corresponds with the associated schema information.
Note that the proofshot also contains values for the implied (non-affordance) properties
that are static (e.g., the physical location assigned to the instance) but still part of
the instance's proofshot as the location is known. <!-- Not really sure about this yet. -->

~~~ json
{
  "info": {
    "title": "An example of the heater #1 in the boat #007",
    "version": "2025-01-27",
    "copyright": "Copyright 2025. All rights reserved."
  },
  "namespace": {
    "models": "https://example.com/models",
    "boats": "https://example.com/boats"
  },
  "defaultNamespace": "boats",

  "sdfInstance": {
    "boat007": {
      "sdfInstanceOf": "models:#/sdfThing/boat",
      "$comment": "TODO: How to deal with wrapped instances..?",
      "sdfInstance": {
        "heater01": {
            "sdfInstanceOf": "models:#/sdfThing/boat/sdfObject/heater",
            "identifier": { "UUID": "a2e06d16-df2c-4618-aacd-490985a3f763" },
            "isHeating": true,
            "location": {
              "wgs84": {
                "latitude": 35.2988233791372,
                    "longitude": 129.25478376484913,
                    "altitude": 0.0
                },
                "postal": {
                  "city": "Ulsan",
                    "post-code": "44110",
                    "country": "South Korea"
                },
                "w3w": {
                  "what3words": "toggle.mopped.garages"
                }
            },
            "report": {
              "value": "On February 24, 2025, the boat #007's heater #1 was on from 9 a.m. to 6 p.m."
            }
          }
        }
      }
    }
  }
}
~~~
{: #code-non-affordance-instance title="SDF instance proposal for draft-lee-asdf-digital-twin-07, Figure 1"}

~~~ json
{
  "info": {
    "title": "An example model of a heater on a boat",
    "version": "2025-01-27",
    "copyright": "Copyright 2025. All rights reserved."
  },
  "namespace": {
    "models": "https://example.com/models"
  },
  "defaultNamespace": "models",

  "sdfThing": {
    "boat": {
      "sdfObject":
        "heater": {
          "sdfProperty": {
            "isHeating": {
              "$comment": "FIXME: Find a better quality name",
              "nonAffordance": true,
              "description": "The state of the heater on a boat; false for off and true for on.",
              "type": "boolean"
            },
            "$comment": "TODO: Could also be removed from the examples",
            "identifier": {
              "type": "object",
              "properties": {
                "UUID": {
                  "type": "string"
                }
              }
            },
            "location": {
              "nonAffordance": true,
              "type": "object",
              "properties": {
                "wgs84": {
                  "type": "object",
                  "properties": {
                    "latitude": {
                      "type": "number"
                    },
                    "longitude": {
                      "type": "number"
                    },
                    "altitude": {
                      "type": "number"
                    }
                  }
                },
                "postal": {
                  "type": "object",
                  "properties": {
                    "city": {
                      "type": "string"
                    },
                    "post-code": {
                      "type": "string"
                    },
                    "country": {
                      "type": "string"
                    }
                  }
                },
                "w3w": {
                  "type": "object",
                  "properties": {
                    "what3words": {
                      "type": "string",
                      "format": "..."
                    }
                  }
                }
              }
            },
            "report": {
              "type": "object",
              "properties": {
                "value": {
                  "type": "string"
                }
              }
            }
          }
        }
      }
    }
  }
}
~~~
{: #code-non-affordance-model title="Revised SDF model proposal for draft-lee-asdf-digital-twin-07, Figure 1"}

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

~~~ json
{
  "info": {
    "title": "Example document for SDF (Semantic Definition Format) with constructors for instantiation",
    "version": "2019-04-24",
    "copyright": "Copyright 2019 Example Corp. All rights reserved.",
    "license": "https://example.com/license"
  },
  "namespace": {
    "cap": "https://example.com/capability/cap"
  },
  "defaultNamespace": "cap",

  "sdfObject": {
    "temperatureSensor": {
      "sdfProperty": {
        "temperature": {
          "description": "Temperature value measure by this Thing's temperature sensor.",
          "type": "number",
          "sdfParameters": [
            "minimum",
            {
              "targetQuality": "minimum",
              "parameterName": "minimum",
              "constructorName": "construct"
            }
            "maximum",
            {
              "targetQuality": "unit",
              "parameterName": "#/sdfObject/Switch/sdfConstructors/construct/temperatureUnit"
            }
          ]
        }
      },
       "sdfConstructors": {
        "$comment": "TODO: Dicuss whether this should be assumed to be the default constructor",
        "construct": {
          "parameters": {
            "minimum": {
              "required": true
            },
            "maximum": {
              "required": false,
              "$comment": "Constructors could allow for further restricting values that can be assigned to affordances",
              "type": "integer"
            },
            "temperatureUnit": {
              "required": false
            }
          }
        }
      }
    }
  }
}
~~~
{: #code-sdf-constructors title="Example for SDF model with constructors"}

##### Example for an SDF construction message

~~~ json
{
  "info": {
    "title": "Example SDF construction message",
    "$comment": "TODO: What kind of meta data do we need here?"
  },
  "namespace": {
    "cap": "https://example.com/capability/cap"
  },
  "defaultNamespace": "cap",
  "sdfConstruction": {
    "sdfConstructor": "cap:#/sdfObject/temperatureSensor/sdfConstructors/construct",
    "arguments": {
      "minimum": 42,
      "temperatureUnit": "Cel"
    }
  }
}
~~~
{: #code-sdf-construction-message title="Example for an SDF construction message"}

### Deltas and Default/Base messages

What changed since the last proofshot?

What is different from the base status of the device?

Can I get the same (equivalent, not identical) coffee I just ordered but with 10 % more milk?

(Think merge-patch.)

A construction message may be a delta, or it may have parameters that
algorithmically influence the elements of state that one would find in
a proofshot.

~~~ json
{
  "info": {
    "title": "Example SDF delta construction message",
    "$comment": "TODO: What kind of meta data do we need here?"
  },
  "namespace": {
    "cap": "https://example.com/capability/cap"
  },
  "defaultNamespace": "cap",
  "sdfConstruction": {
    "sdfConstructor": "cap:#/sdfObject/temperatureSensor/sdfConstructors/construct",
    "previousProofshot": "???",
    "arguments": {
      "currentTemperature": 24
    }
  }
}
~~~
{: #code-sdf-construction-delta-message title="Example for an SDF construction message for proofshot delta"}

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
