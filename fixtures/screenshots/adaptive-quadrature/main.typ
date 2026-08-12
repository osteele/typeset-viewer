#set page(paper: "us-letter", margin: (x: 0.85in, y: 0.75in))
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true, leading: 0.72em)
#set heading(numbering: "1.1")
#set figure(gap: 0.65em)

#align(center)[
  #text(17pt, weight: "bold")[Adaptive Quadrature on Irregular Meshes]
  #v(0.35em)
  #text(10pt)[Mira Chen · Department of Applied Mathematics]
]

#v(0.8em)

#block(inset: 10pt, fill: luma(245), radius: 3pt)[
  *Abstract.* We study an adaptive quadrature rule for functions sampled on
  irregular triangular meshes. A local disagreement score concentrates work
  near sharp gradients while preserving a simple global stopping rule. The
  synthetic example is designed to exercise document navigation, figures,
  tables, citations, notes, and selection actions in Typeset Viewer.
]

= Introduction

Numerical integration on an irregular mesh must separate geometric error from
variation in the sampled field. Uniform refinement spends most of its budget in
smooth regions. An adaptive rule instead estimates where one additional sample
is likely to change the integral. Classical residual methods provide the model
for this strategy @babuska1978.

The local error indicator is useful because it converts disagreement among
neighboring elements into a single refinement score. This sentence is kept
stable so that screenshots can attach a note, select a passage, and verify that
the annotation follows the quote after text is inserted above it.

== Problem statement

Let $cal(T)$ be a triangular partition of a bounded domain $Omega$. For each
element $T in cal(T)$, the rule evaluates a local estimate $Q_T(f)$ and a
cheaper embedded estimate $tilde(Q)_T(f)$. Their disagreement defines

$ epsilon_T = abs(Q_T(f) - tilde(Q)_T(f)), quad
  epsilon = sum_(T in cal(T)) epsilon_T. $ <eq:error>

The algorithm refines the element with the largest weighted value of
$epsilon_T$ until $epsilon$ falls below a user-selected tolerance. This is a
small example, but the same separation between local evidence and a global
budget appears in adaptive finite-element methods @ainsworth2000.

#figure(
  table(
    columns: (1.45fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    table.header([Mesh], [Elements], [Samples], [Relative error]),
    [Uniform], [4,096], [12,288], [1.8%],
    [Gradient only], [2,560], [7,680], [1.2%],
    [Embedded rule], [1,984], [5,952], [0.7%],
  ),
  caption: [Work and error at a fixed refinement budget.],
) <tab:results>

#pagebreak()

= Adaptive rule

The refinement loop keeps a priority queue of elements ordered by estimated
contribution to total error. Each iteration removes one element, evaluates its
children, and updates the running estimate. The rule never needs to revisit an
unrelated part of the mesh.

== Local scoring

We combine estimator disagreement with a geometric penalty,

$ s_T = epsilon_T (1 + alpha rho_T), $

where $rho_T$ measures aspect-ratio distortion and $alpha$ controls the penalty.
The penalty prevents a long, narrow element from looking artificially cheap.

#figure(
  block(width: 82%, height: 118pt, inset: 10pt, fill: rgb("f6f7f9"), radius: 4pt)[
    #align(bottom + center)[
      #box(width: 48pt, height: 34pt, fill: rgb("b8c8dc"), radius: 2pt)
      #h(12pt)
      #box(width: 48pt, height: 55pt, fill: rgb("93abc9"), radius: 2pt)
      #h(12pt)
      #box(width: 48pt, height: 84pt, fill: rgb("6e8db8"), radius: 2pt)
      #h(12pt)
      #box(width: 48pt, height: 48pt, fill: rgb("88a4c5"), radius: 2pt)
      #h(12pt)
      #box(width: 48pt, height: 92pt, fill: rgb("587ba9"), radius: 2pt)
    ]
  ],
  caption: [Normalized local error before the third refinement pass.],
) <fig:local-error>

Figure @fig:local-error shows the deliberately uneven score distribution used
in the screenshots. The third and fifth regions receive the next samples. The
table and figure are synthetic; their purpose is to keep the capture fixture
stable as the application UI changes.

== Stopping rule

The computation stops when the sum of active local estimates satisfies
$epsilon <= tau abs(Q(f)) + tau_0$. A relative tolerance $tau$ handles scale,
while $tau_0$ prevents unnecessary refinement when the integral is near zero.

#pagebreak()

= Evaluation

We evaluate three strategies on the same piecewise-smooth field. The embedded
rule reaches the lowest error with fewer samples, as summarized in
Table @tab:results. More important for this fixture, the surrounding prose
contains citations, cross-references, and enough structure to populate every
navigation sidebar.

== Stability under reflow

Annotations are anchored to selected text rather than to a fixed rectangle on
the rendered page. Insert a paragraph earlier in the document and render again:
the highlighted quote moves, and the attached note moves with it. If the quote
no longer exists, the note remains in the list and is marked as not found in
the current render.

== Limitations

The reported values are illustrative and make no empirical claim. This fixture
is a compact, deterministic document for product screenshots, UI checks, and
manual demonstrations.

= Conclusion

Adaptive sampling directs computation toward the parts of a mesh that can still
change the answer. A stable source document serves a similar role for the web
site: it lets each screenshot change for a product reason instead of because
the example itself drifted.

#bibliography("references.bib", title: "References")
