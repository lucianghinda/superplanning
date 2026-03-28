#!/usr/bin/env bash
# Behavior verification tests for the superplanning skill
# Tests that the skill describes correct phases, rules, and artifacts.
# Usage: bash test-superplanning.sh [--verbose]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

PASSED=0
FAILED=0
RESULTS=()

run_test() {
    local name="$1"
    local func="$2"

    echo "--- $name ---"
    if "$func"; then
        PASSED=$((PASSED + 1))
        RESULTS+=("  [PASS] $name")
    else
        FAILED=$((FAILED + 1))
        RESULTS+=("  [FAIL] $name")
    fi
    echo ""
}

# ---------------------------------------------------------------------------
# Test 1: Three modes recognized
# ---------------------------------------------------------------------------
test_three_modes() {
    local output
    output=$(run_claude "What are the three modes in the superplanning skill?" 120)
    local ok=0
    assert_contains "$output" "brainstorm" "mode: brainstorm" && true || ok=1
    assert_contains "$output" "product" "mode: new product" && true || ok=1
    assert_contains "$output" "feature" "mode: new feature" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 2: Scope classification
# ---------------------------------------------------------------------------
test_scope_classification() {
    local output
    output=$(run_claude "How does the superplanning skill classify scope?" 120)
    local ok=0
    assert_contains "$output" "lightweight" "scope: lightweight" && true || ok=1
    assert_contains "$output" "standard" "scope: standard" && true || ok=1
    assert_contains "$output" "deep" "scope: deep" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 3: Phase ordering (challenge before structure)
# ---------------------------------------------------------------------------
test_phase_ordering() {
    local output
    output=$(run_claude "In superplanning, what comes first: challenging the idea or structuring the implementation plan?" 120)
    assert_order "$output" "challenge\|pressure test\|explore" "structure\|implementation" \
        "challenge before structure"
}

# ---------------------------------------------------------------------------
# Test 4: Anti-sycophancy enforcement
# ---------------------------------------------------------------------------
test_anti_sycophancy() {
    local output
    output=$(run_claude "Does superplanning challenge assumptions or just accept them? How does it handle weak ideas?" 120)
    local ok=0
    assert_contains "$output" "challenge\|push back\|pressure test\|anti-sycophancy\|position" \
        "challenges assumptions" && true || ok=1
    assert_not_contains "$output" "accepts all\|rubber.stamp\|always agrees" \
        "does not rubber-stamp" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 5: One question at a time rule
# ---------------------------------------------------------------------------
test_one_question_at_a_time() {
    local output
    output=$(run_claude "How does superplanning handle asking the user questions? Does it batch questions or ask them individually?" 120)
    assert_contains "$output" \
        "one.*question.*at.*a.*time\|single.*question\|one.*at.*a.*time\|individually" \
        "one question at a time"
}

# ---------------------------------------------------------------------------
# Test 6: Brainstorm mode produces a requirements document
# ---------------------------------------------------------------------------
test_brainstorm_artifacts() {
    local output
    output=$(run_claude "What document does superplanning produce in brainstorm mode?" 120)
    local ok=0
    assert_contains "$output" "requirements.*doc\|requirements.*document" \
        "produces requirements doc" && true || ok=1
    assert_contains "$output" "R1\|stable.*ID\|requirement.*ID\|numbered.*req" \
        "stable requirement IDs" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 7: New product mode produces mission, roadmap, tech stack
# ---------------------------------------------------------------------------
test_new_product_artifacts() {
    local output
    output=$(run_claude "What documents does superplanning produce when planning a new product?" 120)
    local ok=0
    assert_contains "$output" "mission" "produces mission doc" && true || ok=1
    assert_contains "$output" "roadmap" "produces roadmap" && true || ok=1
    assert_contains "$output" "tech.*stack\|technology.*stack" "produces tech stack" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 8: Validation phase exists with named reviewers
# ---------------------------------------------------------------------------
test_validation_phase() {
    local output
    output=$(run_claude "How does superplanning validate plans before implementation?" 120 5)
    local ok=0
    assert_contains "$output" "review\|validate\|validation" "has validation" && true || ok=1
    assert_contains "$output" "persona\|CEO\|design\|eng\|coherence\|feasibility" \
        "names review personas" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 9: Flawed premise stops the flow
# ---------------------------------------------------------------------------
test_gate_on_flawed_premise() {
    local output
    output=$(run_claude "What happens in superplanning if the idea has a flawed premise?" 120)
    assert_contains "$output" "stop\|halt\|reframe\|not.*proceed\|gate\|do not proceed" \
        "stops on flawed premise"
}

# ---------------------------------------------------------------------------
# Test 10: Forcing questions in product mode
# ---------------------------------------------------------------------------
test_forcing_questions() {
    local output
    output=$(run_claude "What forcing questions does superplanning use for new product ideas?" 120)
    assert_contains_at_least "$output" 2 "mentions at least 2 forcing questions" \
        "demand" "status quo" "narrowest wedge" "specificity" "observation" "future"
}

# ---------------------------------------------------------------------------
# Test 11: Implementation units in structure phase
# ---------------------------------------------------------------------------
test_implementation_units() {
    local output
    output=$(run_claude "How does superplanning break down an implementation plan?" 120)
    local ok=0
    assert_contains "$output" "implementation.*unit\|unit\|atomic.*commit\|atomic" \
        "mentions implementation units" && true || ok=1
    assert_contains "$output" "dependencies\|test.*scenario\|verification" \
        "unit has dependencies/test scenarios/verification" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 12: Deepen phase is conditional (not always)
# ---------------------------------------------------------------------------
test_deepen_is_conditional() {
    local output
    output=$(run_claude "When does superplanning's deepen phase run? Is it always or conditional?" 120)
    local ok=0
    assert_contains "$output" "conditional\|optional\|only.*when\|standard.*deep\|high.*risk\|not.*always" \
        "deepen is conditional" && true || ok=1
    assert_not_contains "$output" "always.*runs.*deepen\|deepen.*must always\|deepen.*always runs\|mandatory.*deepen phase" \
        "deepen is not always mandatory" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 13: Documents save to docs/ folder inside the project
# ---------------------------------------------------------------------------
test_artifact_location_is_docs_folder() {
    local output
    output=$(run_claude "Where does superplanning save the documents it creates? What folder?" 120)
    local ok=0
    assert_contains "$output" "docs/" "saves to docs/ folder" && true || ok=1
    assert_contains "$output" "brainstorms\|plans\|product" "names a subfolder" && true || ok=1
    assert_not_contains "$output" "home\|~\|\.claude\|global\|absolute.*path" \
        "not a global/absolute path" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 14: Artifact paths are relative to the project root
# ---------------------------------------------------------------------------
test_artifact_paths_are_relative() {
    local output
    output=$(run_claude "Are the file paths superplanning uses for saving documents absolute or relative? Where are they relative to?" 120)
    local ok=0
    assert_contains "$output" "relative" "paths are relative" && true || ok=1
    assert_contains "$output" "project.*root\|working.*dir\|current.*dir\|project.*folder" \
        "relative to project root" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 15: Phase 3 (Define) is mandatory for New Product mode with all 4 docs
# ---------------------------------------------------------------------------
test_phase3_mandatory_for_product() {
    local output
    output=$(run_claude "In superplanning New Product mode, what happens between the Challenge & Explore phase and the Structure phase? What documents must be created?" 120)
    local ok=0
    assert_contains "$output" "define\|phase 3" "Phase 3 (Define) is named" && true || ok=1
    assert_contains "$output" "mission" "mission.md required" && true || ok=1
    assert_contains "$output" "mvp" "mvp-plan.md required" && true || ok=1
    assert_contains "$output" "roadmap" "roadmap.md required" && true || ok=1
    assert_contains "$output" "tech.*stack\|tech-stack" "tech-stack.md required" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 16: Gate 2->3 requires user confirmation before proceeding
# ---------------------------------------------------------------------------
test_gate_2_3_requires_confirmation() {
    local output
    output=$(run_claude "In superplanning, what must happen at the Gate 2 to 3 transition? Does the assistant just proceed automatically or must it ask the user something first?" 120)
    local ok=0
    assert_contains "$output" "ask\|confirm\|checkpoint\|AskUserQuestion\|user.*respond\|blocking" \
        "gate requires user interaction" && true || ok=1
    assert_contains "$output" "phase 3\|define" \
        "names Phase 3 (Define)" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 17: Q0 (Founder-Market Fit) exists as a forcing question
# ---------------------------------------------------------------------------
test_q0_founder_market_fit() {
    local output
    output=$(run_claude "What is Q0 in superplanning's forcing questions? What does it ask?" 120)
    local ok=0
    assert_contains "$output" "founder.market fit\|unfair advantage\|why.*you\|Q0" \
        "Q0 is about founder-market fit / unfair advantage" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 18: Q0 comes before Q1 in the forcing question sequence
# ---------------------------------------------------------------------------
test_q0_comes_before_q1() {
    local output
    output=$(run_claude "In what order does superplanning ask forcing questions? Which comes first?" 120)
    assert_order "$output" "Q0\|founder.market\|unfair advantage" "Q1\|demand reality" \
        "Q0 before Q1"
}

# ---------------------------------------------------------------------------
# Test 19: Q0 is reframed as domain-expertise fit for engineering/infra
# ---------------------------------------------------------------------------
test_q0_reframed_for_eng_infra() {
    local output
    output=$(run_claude "In superplanning, how does Q0 differ for pure engineering or infrastructure projects compared to product startups?" 120)
    local ok=0
    assert_contains "$output" "domain.*expert\|operational.*exp\|technical.*context\|reframe\|domain.expertise" \
        "Q0 reframed for eng/infra" && true || ok=1
    assert_contains "$output" "seen.*break\|what.*break\|experience\|battle" \
        "asks about operational experience" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 20: Job story must be synthesized before Gate 2->3
# ---------------------------------------------------------------------------
test_job_story_required() {
    local output
    output=$(run_claude "What is the job story in superplanning and when must it be completed?" 120)
    local ok=0
    assert_contains "$output" "job story" "mentions job story" && true || ok=1
    assert_contains "$output" "gate.*2.*3\|gate 2\|before.*proceed\|required\|must\|cannot proceed" \
        "job story required before Gate 2->3" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 21: Job story follows a four-component format
# ---------------------------------------------------------------------------
test_job_story_format() {
    local output
    output=$(run_claude "What is the format of the job story that superplanning synthesizes? What are its components?" 120)
    local ok=0
    assert_contains "$output" "situation\|when.*\[" "has situation component" && true || ok=1
    assert_contains "$output" "pain\|struggle" "has pain component" && true || ok=1
    assert_contains "$output" "workaround\|currently\|so I" "has workaround component" && true || ok=1
    assert_contains "$output" "outcome\|hire.*tool\|help me" "has outcome component" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 22: Mission document includes Job Story and Why We're Right sections
# ---------------------------------------------------------------------------
test_mission_doc_new_sections() {
    local output
    output=$(run_claude "What sections are in the mission.md document that superplanning creates? List all sections." 120)
    local ok=0
    assert_contains "$output" "job story" "mission has Job Story section" && true || ok=1
    assert_contains "$output" "why.*right\|right.*build\|unfair advantage" \
        "mission has Why We're Right section" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 23: Roadmap phases include hypothesis with measurable behavior signal
# ---------------------------------------------------------------------------
test_roadmap_phase_hypotheses() {
    local output
    output=$(run_claude "What does each phase in the superplanning roadmap document require? Does it include a hypothesis?" 120)
    local ok=0
    assert_contains "$output" "hypothesis\|we believe\|we'll know" \
        "roadmap phases include hypothesis" && true || ok=1
    assert_contains "$output" "measurable\|behavior.*signal\|user.*behavior\|specific.*signal\|know.*true" \
        "hypothesis requires measurable behavior signal" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 24: Premise Challenge includes a frequency check on Q1
# ---------------------------------------------------------------------------
test_premise_challenge_frequency() {
    local output
    output=$(run_claude "Does superplanning's Premise Challenge check how often the problem occurs? What does the frequency check ask?" 120)
    assert_contains "$output" "frequent\|frequency\|how often\|daily\|weekly\|rare" \
        "Premise Challenge includes frequency check"
}

# ---------------------------------------------------------------------------
# Test 25: Premise Challenge includes a distribution test (first 10 users)
# ---------------------------------------------------------------------------
test_premise_challenge_distribution() {
    local output
    output=$(run_claude "What is the distribution test in superplanning's Premise Challenge? What does it ask about?" 120)
    local ok=0
    assert_contains "$output" "first.*10.*user\|10.*user\|distribution\|first.*user\|bring.*user" \
        "distribution test is about first 10 users" && true || ok=1
    assert_contains "$output" "channel\|action\|email\|community\|outreach\|specific.*action" \
        "asks for specific distribution action" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Test 26: Mission document includes a "What We'll Do Manually" section
# ---------------------------------------------------------------------------
test_mission_manual_section() {
    local output
    output=$(run_claude "Does the superplanning mission document include a section about what to do manually before automating? What does it ask?" 120)
    local ok=0
    assert_contains "$output" "manual\|manually\|wizard.*oz\|human.*behind" \
        "mission has manual / pre-scale section" && true || ok=1
    assert_contains "$output" "automate\|automated\|not.*automat\|pre.scale\|hypothesis" \
        "challenges automation scope" && true || ok=1
    return $ok
}

# ---------------------------------------------------------------------------
# Run all tests
# ---------------------------------------------------------------------------
echo "========================================"
echo " Superplanning Skill Behavior Tests"
echo "========================================"
echo "Plugin dir: $PLUGIN_DIR"
echo "Time: $(date)"
echo ""

run_test "Three modes recognized" test_three_modes
run_test "Scope classification (Lightweight/Standard/Deep)" test_scope_classification
run_test "Phase ordering: challenge before structure" test_phase_ordering
run_test "Anti-sycophancy enforcement" test_anti_sycophancy
run_test "One question at a time" test_one_question_at_a_time
run_test "Brainstorm artifacts: requirements doc with stable IDs" test_brainstorm_artifacts
run_test "New product artifacts: mission, roadmap, tech-stack" test_new_product_artifacts
run_test "Validation phase with named reviewers" test_validation_phase
run_test "Gate stops flow on flawed premise" test_gate_on_flawed_premise
run_test "Forcing questions for product mode" test_forcing_questions
run_test "Implementation units with required fields" test_implementation_units
run_test "Deepen phase is conditional, not always" test_deepen_is_conditional
run_test "Artifact location: saves to project docs/ folder" test_artifact_location_is_docs_folder
run_test "Artifact paths are relative to project root" test_artifact_paths_are_relative
run_test "Phase 3 (Define) mandatory for New Product with all 4 docs" test_phase3_mandatory_for_product
run_test "Gate 2->3 requires user confirmation before proceeding" test_gate_2_3_requires_confirmation
run_test "Q0: Founder-Market Fit exists as first forcing question" test_q0_founder_market_fit
run_test "Q0 comes before Q1 in forcing question order" test_q0_comes_before_q1
run_test "Q0 reframed as domain-expertise fit for engineering/infra" test_q0_reframed_for_eng_infra
run_test "Job story required before Gate 2->3" test_job_story_required
run_test "Job story has four components: situation, pain, workaround, outcome" test_job_story_format
run_test "Mission doc includes Job Story and Why We're Right sections" test_mission_doc_new_sections
run_test "Roadmap phases include hypothesis with measurable behavior signal" test_roadmap_phase_hypotheses
run_test "Premise Challenge includes frequency check" test_premise_challenge_frequency
run_test "Premise Challenge includes distribution test (first 10 users)" test_premise_challenge_distribution
run_test "Mission doc includes What We'll Do Manually section" test_mission_manual_section

echo "========================================"
echo " Results"
echo "========================================"
for r in "${RESULTS[@]}"; do
    echo "$r"
done
echo ""
echo "  Passed: $PASSED"
echo "  Failed: $FAILED"
echo ""

if [ "$FAILED" -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
