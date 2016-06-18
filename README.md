# Models
A model written in Swift to solve a problem I came across.

## Problem

Given a list of numbers and another list of new value for each number. Each time, only one non zero delta can be applied to a non empty subset of continuous members of the list. The delta needs to minimize the gap between current value and new value for each number applied, while not creating new gap for any member.

## Solution

### Data Structure

* List of targets, not going to change. This is the base to work on. Each time a list of updated values is applied to it to get news answers to approach targets.

* Lists of ranges and corresponding deltas. To know the whole transform clearly, record all changes (including zeros) for each step. Append each step's change after the initial.

* List of lists of updated numbers.

### Calculation

Find out all continuous non-zero-delta-to-reach-target ranges for current numbers. Get max delta necessary for each number in the range for each range. Follow a rule provided to pick the range to operate on. Execute and loop the process till no non-zero-delta-to-reach-target range can be found.

max-deltas: in a continuous range, the max delta that all its members can be added in the progress of reaching each's target, but not over-reaching for any member.

Written in Swift 2.2.

### Lesson learned

Avoiding operating on nested data structures, which could lead to unnecessary complexity while working with extension.
