# The time_static resource is used so that the time is stored in the state
# This means that it only changes when something forces a change, and is the absolute state time
resource "time_static" "state_time" {}
