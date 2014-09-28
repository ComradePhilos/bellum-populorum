#bellum populorum
# War of the tribes

Bellum populorum (war of the tribes/peoples) is an opensource software project made for school. It aims to simulate
a dynamic process - in this case the development and competition of different ancient peoples. On a (pseudo-)
randomly generated map the peoples are generated and then gather resources and food to grow and to gain supremacy.
A simulation might end when there is either no opponent or no space/food left. The peoples will have slight
differences in behavior and their ability to handle the situation they are facing.

## Planned features
<p>
<ul>
<li>Three different peoples</li>
<li>Artificial Intelligence</li>
<li>Randomly generated maps</li>
<li>Support for multiple (simultaneous) simulations</li>
<li>Great 8-Bit graphics (like good old times on Amiga ;))</li>
<li>Tools to manipulate the simulation in some ways</li>
<li>statistics</li>
</ul>
</p>

## Installation

### Linux
You will have to build `bellum populorum` from source. Go to any directory on your system and use the
following commands to build the programme. (Free Pascal Compiler and Lazarus IDE are required)
```bash
git clone https://github.com/comradephilos/bellum-populorum
cd bellum-populorum
lazbuild -B simulation.lpi
```
Afterwards you will find an executable in the "bin"-folder. Make sure it is marked as executable.
You can also open the `simulation.lpi`-file with Lazarus to edit and/or compile the project.

### Windows
Download Lazarus IDE from the official website. Open the `simulation.lpi`-file and edit and/or compile the
project.

## Peoples
There will be 3 different peoples. Their behavior and abilities might not be final, the list might get
extended later. Here are just some thoughts to make the simulation a bit more interesting:

### Romans
Romans are well organized and highly developed. They are very well trained and because of that have a strong
army. But quality does not often come cheap.

### Slavonics
In contrast to the Romans the Slavonics don't have a really strong army or sophisticated equipment. But they are
able to outnumber their opponents. They grow fast and stick together.

### Germans
The Germans will have both bonuses that Romans and Slavonics have. They are not as well equipped as Romans and
not as many as the Slavonics.

<img style="float:left" src="https://dl.dropboxusercontent.com/u/76923843/18092014.png">
