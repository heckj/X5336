# L-systems DSL

Can I create the rules and modules for an L-system with a ResultBuilder?

- What does it look like?
- How does it mesh into Xcode

Things you need to define:

- a "rule", of which there were be many - and makes up the core of L-system
  - A rule includes at least a strict predicate
  - it may also include a 'prev' (L) or 'next' (R) context.
  - Extreme versions can include a 'prev-new' context as well.
    - all of the contexts can be matched against any of their parameters to know
      if a rule should be invoked or not.
  - modules and values from these contexts are available to compute the new modules to replace on a rule 'match'
  - rules can be stochastic as well - in addition to the predicate matching function
  - a rule can invoke some continuation like expression that has access to all the
    incoming parameters and modules, and results in the generation of a "new" module
    that replaces the current edition in the sequence. More than one module can be
    generated and sequenced.
- a "module" - some of which may be built-in, others user-defined. 
  Also known as the 'variables', a sequence of these represents the current state 
  of an l-system.
  - The modules can have parameters - parametric l-systems allow some interesting
    computations, as well as providing a means to pass information to a external
    (visual) representation - either in 2D or in 3D.

## L-system runtime details

Processing Rules
- for each iteration/evolution, iterate over the sequence of the modules, and for each module, check which rules may apply.
  - OPEN QUESTION: Do we apply the first and then move on, or do we collect and apply ALL that could be applied in the sequence that they're identified?
  - If no matching rule is found, the node "drops through" and is left unchanged.
  - a rule *can* be stochastic - so if it matches, there's a percentage change that it will be triggered. The examples from The Algorithmic Beauty of Plants made it look like there was a predicate that was generally matched, and then a collection of stochastic rules that for the generated results that sum'd up to 100%.
  
