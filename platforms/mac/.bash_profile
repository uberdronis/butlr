clear

RED="\x1B[1;31m"
GREEN="\x1B[0m"

echo -e "${RED}"
echo "  When life gives you lemons, don't make lemonade. Make life take those lemons back! Get mad!"
echo "  I don't want your damn lemons, what the hell am I supposed to do with these?? Demand to see"
echo "  life's manager! Make life rue the day it thought it could give Cave Johnson lemons!! Do you"
echo "  know who I am? I'm the man who's gonna burn your house down! With the lemons! I'm gonna get"
echo "  my engineers to invent a combustible lemon that burns your house down!!!  --Cave Johnson"
echo -e "${GREEN}"

# process bashrc
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
