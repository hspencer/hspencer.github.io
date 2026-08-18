---
layout: post
type: posts
title: "Connecting the Dots, Connecting the Places, Building the Path"
permalink: /2026/connecting-the-dots
description: "On Vera, a personal knowledge tool, and on the walk as a third thing between the map and the text."
date: 2026-08-18
categories:
- ideas
- research
published: true
tags:
- vera
- pkm
- knowledge-graph
- interaction-design
- AI
- memex
- mediafranca
image:
  path: https://vera.mediafranca.net/assets/vera-interface.png
  alt: "Vera showing a page and its graph of relations"
---

#### Two panels

I think in graphs, which is half a confession, since the graph is only the map.

The map is where you stand before the whole: a topological image of distances and proximities, concepts with fuzzy edges, correspondences appearing pass after pass as the picture gains resolution. The text is the other half: the inside, the singular, the punctual, what can barely be said and sometimes is a drawing or a note. The two are given together because they are a relation. To stand before something and to know yourself inside it is the basic operation of orientation, the way a person locates themselves in the world.

Left there it is a dualism, and it resolves the way oppositions resolve, through a third thing.

#### The third thing is the walk

Think of a visitor who arrives from outside, and you compose the city for them. The order of the factors alters the product absolutely. Ending at the top of the hill with the whole city at your feet is a different experience from beginning with the whole city and then submerging into it.

The route is a new text. It is not a point inside the map and it is not a collection of points. It is a walk, because going and returning are not of equal fortune: you go away in order to return, and you return in order to tell a story. That is the fold where the interior becomes exterior, and it becomes exterior through hospitality.

[Vera](https://vera.mediafranca.net) is the tool I am building to hold both panels((Source at [github.com/hspencer/vera](https://github.com/hspencer/vera), AGPL-3.0. Research alpha: one person, one graph. The behaviour is governed by [Allium specifications](https://github.com/hspencer/vera/tree/main/specs) that are readable before any code is.)). It accumulates nodes, ideas, references, claims, data, drawings, voice recordings, testimonies, and it lets several AIs work inside that memory as identifiable collaborators, each intervention keeping its provenance while the person keeps editorial authority. All of that is material. The design problem I have been inside this month is how to formalise the walk. In Spanish we call it *el hilván*, the basting thread, and no accumulation produces it, because it has to be invented.

#### The crossing

The smallest unit turned out to be the step from A to B, which is neither a node nor an edge. Vera calls it a crossing, and it has two faces.

The derived face belongs to the graph and answers one question: was there already something here, or is the guide putting it there. A crossing is *by path* when the corpus already joined those two pages in a sentence, and *across open ground* when it did not. The written face belongs to the guide: the connective, the phrase that carries a reader from one stop to the next. It is derived from nothing, because it was not there before.

Which gives a definition worth the trouble. A trail is a chain of crossings that somebody has declared, in this order, for this reason. It is the first directed thing in the system, since a graph of mentions has all the relations and no direction at all. A trail is an argument whose premises are places in the corpus and whose thread is the voice of whoever composed it, and the connectives are the only thing the trail itself contributes.

The same sentence then says three things. A trace is a chain of crossings nobody has written on yet. An ordinary page is a chain nobody has declared. A trail is a chain declared. Any page could be seen as a thread, which stopped being a nice observation and became an identity.

There is even an arithmetic of it. An argument tends toward the straight line, so a twelve-stop trail left to the forces of the map alone falls into a tangle, and a tangle does not read as a walk. Two soft springs correct it: the elbow, which pulls each stop toward the midpoint of its two neighbours on the thread, and the step, which moves each leg toward the average length. They accompany the graph forces without beating them, because a trail straightened completely would draw every trail the same, and the shape of an argument, a detour that returns, a star from a single place, is exactly what its map has to say.

#### Eighty years

Vannevar Bush saw the far end of this in 1945. The worth of a trail, he wrote, is that its owner passes it to a friend for insertion in his own Memex, so that trails entwine((Vannevar Bush, ["As We May Think"](https://www.theatlantic.com/magazine/doc/194507/bush), *The Atlantic*, July 1945.)). Eighty years later no program has built it.

I recognise the same figure at the centre of my doctoral project. The generative pipeline of the pictograms is a path of exactly this kind: neither map, nor text, nor outline, but the record of how somebody got from an intention to a form, kept so that another person can walk it and disagree with it.

So the tools are the subject now. For the first time we can build the instruments that amplify particular intellectual styles, which makes those instruments something a university ought to hand its students, keep as subject matter, and hold permanently on trial, on ground that is playful and sovereign, where each person can build their own. That is what Illich meant by convivial tools((Ivan Illich, *Tools for Conviviality*, Harper and Row, 1973.)).

And perhaps it is also what a doctorate is: an account of a path. Mine has led me to build machines for the path.
