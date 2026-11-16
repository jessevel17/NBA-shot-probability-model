# NBA Shot Make Probability Model

An interpretable logistic regression model built in R to evaluate individual NBA shot quality and expected make probability using historical shot-tracking data[cite: 2, 3]. Designed to provide actionable insights for front-office evaluation and coaching staff game-planning[cite: 3, 5].

![Logistic Regression Feature Coefficients](output/feature_importance.png)

## Objective
Quantify the baseline probability of a shot going in based on spatial mechanics, defensive pressure, and play context[cite: 3]—isolating shot quality from short-term shooting variance[cite: 5].

## Methodology & Feature Engineering
* **Model Architecture:** Binomial logistic regression (`glm` in R) utilizing intercept suppression (`shottype - 1`) so each shot category estimates its own standalone log-odds baseline rather than penalizing categories relative to an arbitrary reference level[cite: 2, 4].
* **Spatial & Defensive Interaction (`distance * closestdefdist`):** Captures how defender spacing scales with shot distance (e.g., a defender 3 feet away at the rim alters shot difficulty far more than a defender 3 feet away behind the three-point arc)[cite: 2, 3].
* **Context & Rhythm Features:** Incorporates `shotclock`, `dribblesbefore`, `shooterspeed`, `gamestate` (halfcourt vs. transition), court coordinates (`locationx`, `locationy`), and `num_contesters`[cite: 2, 3].
* **Variable Pruning:** Removed redundant binary indicators (`three` and `contested`) to eliminate multicollinearity and coefficient distortion[cite: 4].

## Key Findings
* **Shot Type Hierarchy:** Dunks yield the highest positive log-odds impact (~+1.69), followed by layups (~+0.21) and jumpers (~+0.04), whereas tips and heaves carry the steepest negative coefficients[cite: 1].
* **Defensive Pressure vs. Spacing:** Additional contesting defenders (`num_contesters`) sharply reduce make probability[cite: 1, 3], while greater distance from the primary defender (`closestdefdist`) steadily increases expected conversion[cite: 1].
* **Distance Decay:** Shot distance exerts a consistent negative pull on make probability, moderated by defender proximity[cite: 1, 5].

## Front-Office & Coaching Applications
* **Shot Quality Evaluation:** Assess player and lineup offensive process independent of small-sample shooting slumps[cite: 5].
* **Shot-Making Over Expectation:** Compare actual FG% against model-predicted make probability to identify elite tough-shot makers and inform play-calling[cite: 5].
* **Matchup Targeting:** Quantify how specific defender proximities and contest densities impact individual efficiency[cite: 5].

## Future Extensions
* **Defender Closing Velocity:** Incorporate tracking velocity vectors to distinguish early, on-time, and late closeouts[cite: 5].
* **Player Skill Priors:** Apply Empirical Bayes hierarchical adjustments to account for baseline shooter skill alongside shot difficulty[cite: 5].

## Tech Stack
* **Language:** R (`tidyverse`, `broom`, `ggplot2`)[cite: 2]

---
*Note: Raw tracking datasets and test predictions used during development are excluded from this repository to respect data privacy.*
