# What is in this folder?
Quadrotor Program file for Kandai's research


## File Structure
 - main 
 	- main program. initial setup, controller design, figures are included
 - setStateSpace_lqr
 	- quadrotor model and its augmented model
 - getLqrGain
 	- calculating lqr gains
 - rungekutta
 	- rungekutta simulation for normal lqr with same gain as proposed method
 - rungekutta_explqr
 	- rungekutta simulation for propsed method
 - getNonlineardx_body
 	- None-Linear Model is described 
 - drawFigures
 	- all figures are included in this folder

 	
## references
### Quadrotor Model
 - K. N. Tran, “Modeling and Control of Quadrotor in a Wind Field”, McGill University, 2015
 - F. Sabatino, “Quadrotor control: modeling, nonlinear control design, and simulation”, KTH, 2015
 - Modeling and control of a quadrotor in a wind field

### Wind Model
 - Wind Disturbance Estimation and Rejection for Quadrotor Position Control

### Controller Design
 - Use of Frequency Dependence in Linear Quadratic Control Problems to Frequency-Shaped Robustness
 - Modeling and control of a quadrotor in a wind field
 - 周波数依存重みを用いたLQG制御系の設計
 - Frequency-Shaped Cost Functional Extension of Linear Quadratic Gaussian Design Methods