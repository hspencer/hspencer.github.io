---
layout: post
type: posts
title: "The Right Handles"
permalink: /2026/the-right-handles
description: "On designing tools that let AAC professionals remain the authors of the pictograms they produce, not spectators of what a model decides for them."
date: 2026-02-25
categories:
- research
- ideas
tags:
- doctoral-studies
- practice-led-research
- design-research
- AAC
- pictonet
- pictograms
- pictos
- AI
image:
  path: /assets/uploads/2026/02/let_s_see_together_the_magnifi.svg
  alt: "Two figures facing a shared space of signs, symbols, and questions"
---

Between a phrase and a pictogram there is a gap. Not just a technical gap, the kind engineers like to close, but a space full of decisions that somebody has to make: what to show, what to leave out, how abstract to be, how to arrange elements so the image means what it needs to mean for a particular person in a particular situation. Professionals who work in augmentative and alternative communication navigate this gap every day, largely by instinct. They have experience but not explicit maps. They make good choices but cannot always say why, or point to where exactly the choice was made.

My doctoral research at AUT asks a simple question about that gap: which of those decisions can be surfaced, made visible, and put under someone's hand?

#### What I mean by handles

When you use a generative model to produce an image, you type a prompt and get a result. You can accept it or reject it. That is one handle, and it is crude: it gives you a verdict but no grip on the process. You cannot reach into the image and say *this particular feature is wrong, change it while keeping everything else*. You cannot record *why* you rejected version three and preferred version five. You cannot trace, weeks later, what reasoning led to the pictogram that a student now relies on.

In AAC practice, this matters. Pictograms are not illustrations. They are communicative infrastructure: symbols that people learn, reuse, and depend on to navigate their day. A speech-language therapist who chooses a pictogram for *take the bus* is not decorating a page; she is making a commitment that this image will mean this thing, reliably, across settings. If a generative tool produces that image, the professional must still own the decision. The tool proposes; the professional authors.

The phrase "the right handles" names the design problem. Not more automation, not faster output, but the right points of intervention: places where a professional can inspect what the system did, adjust what needs adjusting, and leave a trace of why.

#### The situation

The pictogram libraries that dominate AAC practice((Primarily ARASAAC, designed by Sergio Palao and published by the Government of Aragon under a CC BY-NC-SA licence, and the proprietary PCS/Boardmaker set by Mayer-Johnson.)) were built for young children. Their visual register shows it: rounded figures, simple outlines, a representational style calibrated to early childhood. This is not a minor aesthetic complaint. For an autistic young person learning to manage a household, use public transport, or speak up for themselves, childish-looking communication materials carry a real cost in dignity((Zisk and Dalton (2019) document the relationship between age-appropriateness in AAC materials and willingness to use the system. The issue is not taste; it is participation.)).

These libraries are also finite. They cover common vocabulary well but cannot anticipate every situated need. When a professional in Santiago needs a pictogram for *scan the Bip card on the bus reader*, no library will contain it. The workarounds are familiar: combine existing symbols, accept a near-match, draw something by hand. Each workaround shifts meaning, breaks visual consistency, and adds time that practitioners do not have.

Generative image models could close this gap. They are fast, cheap, and increasingly capable. But the way we currently use them, prompt in, image out, leaves the professional with almost no control over the things that matter most: which features are depicted, at what level of abstraction, in what style relative to the rest of the set, and why. Worse, it leaves no record. A pictogram generated on Tuesday and accepted without documentation becomes untraceable by Friday. This is at odds with how AAC work actually operates: a cycle of proposing, checking, revising, and re-validating, where decisions must be justifiable and retrievable because the symbols will be taught, shared, and reused across people and settings((Draffan et al. (2023) and Zastudil et al. (2024) both note the tension between the speed of generative output and the accountability demands of professional AAC practice.)).

#### The question

My research asks:

> How can generative image tools be designed to make the construction of AAC pictograms inspectable and controllable by the professionals responsible for validating them?

This is an interaction design question, not a machine learning question. The models already generate images. What does not yet exist is the interface: the set of representations, controls, and documentation structures through which a professional can author a pictogram using generative means while retaining full visibility over the process.

#### PictoNet

The project builds around [PictoNet](/2025/PictoNet), a proof-of-concept text-to-pictogram system I have been developing as part of this doctorate. I have written about its [early motivations](/2025/02/prologo-para-pictonet/) and [broader architecture](/2025/PictoNet) here before. The system takes a phrase, analyses its communicative intent and visual components, and produces a structured SVG where each element is labelled, editable, and traceable back to a decision.

<img src="/assets/uploads/2026/02/let_s_see_together_the_magnifi.svg" title="Let's see together the magnificent spectacle of language" style="width: 55%; height: auto; margin: 2em auto; display: block;" />
<p class='caption'>PictoNet pictogram for <em>"let's see together the magnificent spectacle of language"</em>. The SVG file contains, alongside the drawing, a full semantic record: the original utterance, its pragmatic classification, the NSM primes, the role of every visual element, and the provenance of the generation. The image is its own documentation.</p>

PictoNet is not a product. It is a design probe((In research-through-design, a probe is a deliberately incomplete artefact built to provoke questions rather than to answer them. Its value lies not in what it solves but in what it makes visible.)): an artefact built to make professional judgement visible and to evolve through the questions it raises when real practitioners use it. The point is not to deliver a finished tool but to discover, through making, what the right handles actually are.

This means treating generative AI not as a solution but as a design material((Liao et al. (2023) propose the concept of a *designerly understanding* of AI: practical knowledge about how a model behaves and when to intervene. For AAC work, this translates directly into the question of what controls the interface must expose.)): something with properties, resistances, and affordances that must be learned through practice. In AAC, this carries ethical weight. These pictograms directly affect communication for people with complex needs. Getting the depiction wrong is not an aesthetic failure; it is a communicative one. The requirements for professional oversight, transparency, and accountability are not optional extras. They are the design brief.

#### The SVG as single source of truth

There is a design decision in PictoNet that deserves its own remark. Each pictogram is produced as an SVG file, and that file is not merely a drawing. It carries, inside its `<metadata>` element, a structured JSON record of everything the system knew and decided at the moment of generation: the original utterance, its pragmatic classification (hortative, commissive, volitional), the Natural Semantic Metalanguage primes((NSM, or Natural Semantic Metalanguage, reduces language to a minimal set of universal concepts (Wierzbicka, 1996). PictoNet uses these primes as a bridge between linguistic analysis and visual composition: they name what the pictogram must express at its most elemental level.)) that anchor the visual composition, the frame-semantic roles of each element, and the provenance of the generation itself (model version, timestamp, licence).

This is not metadata for the sake of thoroughness. It is the mechanism through which the pictogram becomes inspectable. A therapist can open the file and see not just the image but the reasoning behind it: why this element was placed here, what concept it maps to, what the system interpreted as the communicative intent. If she disagrees, she can change the drawing and update the record. If a colleague inherits the file six months later, the rationale is still there. The SVG is simultaneously the artefact and its documentation, the pictogram and the audit trail. One file, one truth((This approach draws on a long-standing principle in information design: that the representation and the data it carries should not be separated. Edward Tufte's insistence on graphical integrity, and the broader tradition of structured graphics from ISOTYPE onward, both point in this direction. In PictoNet, SVG makes it technically possible.)).

#### What I am looking for

Four things:

1. The decision criteria AAC professionals actually use when they accept, reject, or revise a pictogram. Not what the literature says they should use, but what they do.
2. A proof-of-concept system that exposes those decisions as inspectable, controllable steps within a generation workflow.
3. Evidence, gathered through co-design, of whether the system's controls actually help professionals locate and repair problems in generated pictograms.
4. A documented account of the design decisions and their rationales, as a methodological contribution to research-through-design with generative AI.

#### Why Chile, why now

AAC research has been developed overwhelmingly in English-language settings. The dominant libraries carry the visual conventions and cultural assumptions of Europe and North America. This project generates design knowledge from Chilean professional practice, in Spanish, with a population whose needs remain largely absent from the international literature.

Chile presents specific conditions that sharpen the problem. A culturally diverse population((Over one in ten Chileans identify as indigenous, reaching one third in some regions (INE 2025).)). A public discourse around autism that has historically infantilised autistic people, framing them as permanent children rather than as adults with lives, routines, and communicative agency of their own. Recent legislation, Ley 21.545 (2023), now recognises adults with autism as rights-holders across education, health, and social participation, but leaves the transition to independent living practically unaddressed as explicit policy. In this context, pictogram materials that are age-appropriate, locally situated, and produced with professional accountability are not a refinement. They are a matter of dignity.

#### A constructive turn

I have [written before](/2025/riding/the/wave) about the centaur moment: the brief window where AI extends human capability rather than replacing it. This doctoral project is an attempt to work inside that window with care. Not by refusing generative tools, and not by accepting their output uncritically, but by designing the conditions under which professional intelligence can guide, inspect, and correct what the model produces.

The contribution will not be a finished product. It will be a documented account of what happens when you treat generative AI as a material to be shaped rather than a service to be consumed. The aim, throughout, is to keep the professional as the author of every pictogram that enters someone's communication system.

The code is on [GitHub](https://github.com/hspencer/pictonet). The work continues.
