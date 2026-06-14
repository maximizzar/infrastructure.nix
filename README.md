# Infrastructure.nix: Homelab but complicated

## Shit I know that's not done (there's more I guess)

**TODO: networking**:
Collapse lan namespace into the 0th ip network.
I want to put core services there.

**TODO: Setup Nameservers**
I want a structured nameserver setup.
IP networks and nameservers should go hand in hand.

This will greatly improve debugging with named ips through PTRs.

Then I also don't have issues with dns hierarchy doing it like that.

**TODO: Put common container logic in module**
Every container needs some setup code that's always the same. 
Put it in a module so I can be activated where needed.


**TODO: add more things to this list, or remove it and push to main already!**
