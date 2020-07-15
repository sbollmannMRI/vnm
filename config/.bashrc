#things in .bashrc get executed for every subshell
if [ -f '/usr/share/module.sh' ]; then source /usr/share/module.sh; fi
export MODULEPATH=/vnm/containers/modules
export SINGULARITY_BINDPATH=/vnm/
alias ll='ls -la'
echo 'These tools are currently installed - use "ml load <tool>" to use them in this shell:'
if [ -f '/usr/share/module.sh' ]; then module avail; fi