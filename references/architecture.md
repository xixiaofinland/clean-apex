# 3-Tier Architecture

## Entry-Point Layer

Classes that have the event triggered, such as REST endpoints, batch, scheduled jobs.
These classes should have minimal logic and delegate logic to the service layer.

## Service Layer (Static)

Service layer are static classes which orchestrate business logic.
DML actions must happen in the Service layer rather than in the OO layer.

## OO Layer

Object Oriented layer encapsulates heavy business logic, calculate and construct
object instances in memory and return back to the caller (Service class).
There must not be DML in OO classes.
