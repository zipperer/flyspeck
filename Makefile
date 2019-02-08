HOL_NATIVE_DIR=/Users/monad/Work/git/forks/hol-light-my
FORMALIZATION_DIR=text_formalization

CAMLP5_PATH=
CAMLP5=camlp5r pa_lexer.cmo pa_extend.cmo q_MLast.cmo -I $(HOL_NATIVE_DIR) pa_j.cmo

OPT_ML=ocamlopt -c -pp "$(CAMLP5_PATH)$(CAMLP5)"
OPT_MLI=$(OPT_ML)
OPT_HL=ocamlopt -c -pp "$(CAMLP5_PATH)$(CAMLP5) -impl"
OPTIONS=

DIRS=\
	$(HOL_NATIVE_DIR) \
	$(HOL_NATIVE_DIR)/Rqe \
	$(HOL_NATIVE_DIR)/Library \
	$(HOL_NATIVE_DIR)/Multivariate \
	$(FORMALIZATION_DIR)/build \
	$(FORMALIZATION_DIR)/general \
	$(FORMALIZATION_DIR)/leg \
	$(FORMALIZATION_DIR)/jordan \
	$(FORMALIZATION_DIR)/trigonometry \
	$(FORMALIZATION_DIR)/nonlinear \
	$(FORMALIZATION_DIR)/volume \
	$(FORMALIZATION_DIR)/hypermap \
	$(FORMALIZATION_DIR)/fan

INCLUDE=$(addprefix -I ,$(DIRS))

HOL_SRC0=\
	system.ml \
	lib.ml \
	fusion.ml \
	basics.ml \
	nets.ml \
	printer.ml \
	preterm.ml \
	parser.ml \
	equal.ml \
	bool.ml \
	drule.ml \
	tactics.ml \
	itab.ml \
	simp.ml \
	theorems.ml \
	ind_defs.ml \
	class.ml \
	trivia.ml \
	canon.ml \
	meson.ml \
	firstorder.ml \
	metis.ml \
	quot.ml \
	impconv.ml \
	pair.ml \
	nums.ml \
	recursion.ml \
	arith.ml \
	wf.ml \
	calc_num.ml \
	normalizer.ml \
	grobner.ml \
	ind_types.ml \
	lists.ml \
	realax.ml \
	calc_int.ml \
	realarith.ml \
	real.ml \
	calc_rat.ml \
	int.ml \
	sets.ml \
	iterate.ml \
	cart.ml \
	define.ml \
	hol_core.ml \
	Library/wo.ml \
	Library/card.ml \
	Library/floor.ml \
	Multivariate/misc.ml \
	Multivariate/vectors.ml \
	Library/products.ml \
	Library/permutations.ml \
	Multivariate/determinants.ml \
	Library/iter.ml \
	Multivariate/metric.ml \
	Multivariate/topology.ml \
	Multivariate/convex.ml \
	Library/frag.ml \
	Library/grouptheory.ml \
	Multivariate/homology.ml \
	Multivariate/paths.ml \
	Multivariate/polytope.ml \
	Multivariate/degree.ml \
	Multivariate/derivatives.ml \
	Multivariate/integration.ml \
	Multivariate/measure.ml \
	Multivariate/complexes.ml \
	Multivariate/canal.ml \
	Multivariate/transcendentals.ml \
	Library/binomial.ml \
	Multivariate/realanalysis.ml \
	Multivariate/geom.ml \
	Multivariate/cross.ml \
	Multivariate/flyspeck.ml

EXTRA_HOL_SRC0=\
	Library/rstc.ml \
	Rqe/num_calc_simp.ml

FLYSPECK_SRC0=\
	general/state_manager.hl \
	general/prove_by_refinement.hl \
	build/native_strictbuild.hl \
	general/hol_library.hl \
	general/print_types.hl \
	general/lib.hl \
	general/flyspeck_lib.hl \
	general/sphere.hl \
	general/hales_tactic.hl \
	general/truong_tactic.hl \
	leg/basics.hl \
	leg/geomdetail.hl \
	leg/aff_sgn_tac.hl \
	leg/affprops.hl \
	leg/cayleyr.hl \
	leg/mur.hl \
	leg/enclosed.hl \
	leg/collect_geom.hl \
	leg/collect_geom2.hl \
	jordan/refinement.hl \
	jordan/lib_ext.hl \
	jordan/hash_term.hl \
	jordan/parse_ext_override_interface.hl \
	jordan/goal_printer.hl \
	jordan/real_ext.hl \
	jordan/tactics_jordan.hl \
	jordan/num_ext_nabs.hl \
	jordan/taylor_atn.hl \
	jordan/float.hl \
	jordan/flyspeck_constants.hl \
	jordan/misc_defs_and_lemmas.hl \
	general/tactics.hl \
	general/vukhacky_tactics.hl \
	trigonometry/trigonometry1.hl \
	trigonometry/trigonometry2.hl \
	trigonometry/delta_x.hl \
	trigonometry/euler_complement.hl \
	trigonometry/euler_multivariate.hl \
	trigonometry/euler_main_theorem.hl \
	trigonometry/trigonometry.hl \
	trigonometry/hvihvec.hl \
	nonlinear/calc_derivative.hl \
	nonlinear/ineqdata3q1h.hl \
	nonlinear/types.hl \
	nonlinear/nonlin_def.hl \
	nonlinear/ineq.hl \
	nonlinear/main_estimate_ineq.hl \
	nonlinear/nonlinear_lemma.hl \
	nonlinear/functional_equation.hl \
	nonlinear/optimize.hl \
	nonlinear/function_list.hl \
	nonlinear/merge_ineq.hl \
	volume/vol1.hl \
	hypermap/hypermap.hl \
	fan/fan_defs.hl \
	fan/fan.hl \
	fan/gmlwkpk.hl \
	fan/fan_topology.hl \
	fan/fan_misc.hl \
	fan/planarity.hl \
	fan/hypermap_and_fan.hl \
	fan/Conforming.hl \
	fan/polyhedron.hl


HOL_SRC=$(addprefix $(HOL_NATIVE_DIR)/,$(HOL_SRC0))
EXTRA_HOL_SRC=$(addprefix $(HOL_NATIVE_DIR)/,$(EXTRA_HOL_SRC0))
FLYSPECK_SRC=$(addprefix $(FORMALIZATION_DIR)/,$(FLYSPECK_SRC0))

HOL_OBJ=$(HOL_SRC:.ml=.cmx)
EXTRA_HOL_OBJ=$(EXTRA_HOL_SRC:.ml=.cmx)
FLYSPECK_OBJ=$(FLYSPECK_SRC:.hl=.cmx)

%.cmi : %.mli
	$(OPT_MLI) $(OPTIONS) $(INCLUDE) $^

%.cmx : %.hl
	$(OPT_HL) $(OPTIONS) $(INCLUDE) -impl $^

%.cmx : %.ml
	$(OPT_ML) $(OPTIONS) $(INCLUDE) $^

.PHONY: clean all flyspeck-compile

all: flyspeck

flyspeck-compile: $(EXTRA_HOL_OBJ) $(FLYSPECK_OBJ)
	@echo "Flyspeck compiled" $(FLYSPECK_OBJ)

flyspeck: flyspeck-compile
	ocamlopt -linkall -o flyspeck unix.cmxa nums.cmxa $(OPTIONS) \
		 $(INCLUDE) $(HOL_OBJ) $(EXTRA_HOL_OBJ) $(FLYSPECK_OBJ)

clean:
	find $(FORMALIZATION_DIR) -name "*.cmi" -delete \
		-o -name "*.cmx" -delete \
		-o -name "*.o" -delete