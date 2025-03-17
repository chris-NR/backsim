## A Sample application to reproduce an impeller performance issue
### Overview
* Simulates a long running background task with updates to state to show progress.
* Uses a Cubit to manage state.
* Creates a view with a custom painted background and a floating action button to start/stop the simulation.
* During the simulation no progress updates are rendered by the view, this is deliberate to demonstrate this issue.
### Results
Can be found in the performance directory