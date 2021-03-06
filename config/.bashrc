#things in .bashrc get executed for every subshell
if [ -f '/usr/share/module.sh' ]; then source /usr/share/module.sh; fi
export MODULEPATH=/vnm/containers/modules
export SINGULARITY_BINDPATH=/vnm/
alias ll='ls -la'

if [ -f '/usr/share/module.sh' ]; then
        if [ -d ${MODULEPATH} ]; then
                echo 'These tools are currently installed - use "ml load <tool>" to use them in this shell:'
        module avail
        else
                echo 'Neurodesk tools not yet downloaded. Choose tools to install from the Application menu.'
        fi
fi
