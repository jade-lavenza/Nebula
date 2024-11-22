/decl/modpack/mutation_traits
	name = "Mutation Traits"
	desc = "Adds traits to the character creation menu, inspired by mutations from Caves of Qud."

/decl/trait/mutation
	category = "Mutations"
	abstract_type = /decl/trait/mutation
	trait_cost = 1
	available_at_chargen = TRUE

/decl/trait/mutation/defect
	category = "Mutations (Defects)"
	abstract_type = /decl/trait/mutation/defect
	trait_cost = -1

/decl/trait/malus/impaired_vision
	name = "Myopia"
	category = /decl/trait/mutation/defect::category