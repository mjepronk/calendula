# Calendula - Créer des calendriers iCalendar sans soucis!

<img src="img/calendula-officinalis.jpg" alt="Calendula Officinalis botanical drawing by Kohler" width="200" style="float: right" />

Would you like to have your country's holidays included? Please send a pull
request.

## Install

```bash
git clone https://github.com/mjepronk/calendula/
cd calendula
stack build --copy-bins
```

## Usage

```bash
# Create an iCalendar file with weeknumbers for the current year...
calendula -w weeknumbers.ics

# ...or for all years between 2020 and 2030
calendula -w -f 2020 -t 2030 weeknumbers.ics

# Create an iCalendar file with all holidays in France:
calendula --fr -f 2020 -t 2030 joursfériés.ics
```
