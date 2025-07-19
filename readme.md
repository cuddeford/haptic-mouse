# Haptic Mouse
The interaction between humans and their tools is constantly undergoing optimisation and refinement. We are ultimately aiming to reduce the gap between our desire and the object of desire. We are trying to collapse the distance between our intention and the action. Our smartphones buzz, tap, and click, based on different interations and this serves to connect the abstraction of the task with the body, with immediate experience. Our digital lives are abstract fictions and interacting with them ought to feel direct. Spatial computing aims to bridge this gap where our abstractions and fictions exist in the "real" world. Instead of having to use a mouse to move a pointer to drag a window around space instead I can just reach my hand out and move it, as if it were an object in 3D space.

Anyway, haptics are a great way to make an abstraction feel real and grounded and connected. Smartphones and smartwatches use haptics well but what if we could extend that experience to a desktop mouse?

The idea involves modifying a mouse to house a haptic motor and have it trigger based on certain interactions on the operating system.

The proof of concept in this repo instead uses an iOS app to trigger the iPhone's haptics in response to hovering over links on any webpage. A simple Chrome extension sends a POST request (or WS) to the server running on the iOS app, triggering the requested haptic. The watchos branch aims to extend this to use the Apple Watch's haptics instead but it's still WIP.
