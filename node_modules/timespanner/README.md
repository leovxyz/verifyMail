# Timespanner
Control time with strings like '(Pacific/Auckland)now/d+5d6h'

## Parsing
1. The string is checked against iso8601 and returned if valid
2. (optional) "(Timezone)" at the start (defaults to UTC)
3. (optional) "now" or another identifier (defaults to now)
4. A series of operations that add or remove durations, round to the start of duration mesurements and change the timezone of the operations.

## Examples
- `now` = The current timestamp in UTC
- `(Pacific/Auckland)now` = The current timestamp in the current timezone for Pacific/Auckland
- `+1day` = The current timestamp plus one day in UTC
- `/day+1day` = The start of today plus one day, so the start of tomorrow in UTC
- `(Pacific/Auckland)/week` = The start of the week in Pacific/Auckland
- `/w+d5h` = One day 5 hours after the start of the week in UTC
- `+5h/d` = The start of the day in five hours time in UTC
- `(UTC)/w(Pacific/Auckland)+4h` = The start of the UTC week, plus four hours in the Pacific/Auckland timezone (e.g. for daylight savings)
- `/d(Pacific/Auckland)` = The start of UTC today in Pacific/Auckland time