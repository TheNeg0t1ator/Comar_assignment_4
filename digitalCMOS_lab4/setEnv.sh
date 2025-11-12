# ES&S Cadence IC 6.1.8.218 (Release 2022)
export CADHOME=/opt/cadence/2022/installs
export CDS_LIC_FILE=27002@license-extern.esat.kuleuven.be

################################################################################
## IC6 Section
################################################################################
export CDS_IC=$CADHOME/IC618 
export CDSDIR=$CDS_IC
export CDSHOME=$CDSDIR

export PATH="$PATH:$CDSHOME/tools/bin:$CDSHOME/tools/dfII/bin"

export CDS_Netlisting_Mode="Analog"
export MG_ENABLE_PTOT=true
export CDS_USE_PALETTE
export CDS_AUTO_64BIT=ALL

alias help_cds_ic='$CDSHOME/tools/bin/cdnshelp &'

# virtuoso

# RHEL8 workaround
if [ -e /etc/redhat-release ]; then
  if grep -q 'release 8' /etc/redhat-release; then
    export OA_UNSUPPORTED_PLAT=linux_rhel60
  fi
fi

# virtuoso 
###############################################################################
# /End IC6 Section
###############################################################################
# END_CDS IC

# START_CDS ASSURA
##############################################################################
## IC6 Assura Section - Assura version compatible with IC6 only
## Do not use with IC5
##############################################################################
# NOTE: For use with IC6
export CDS_ASSURA=$CADHOME/ASSURA618/ 
export ASSURAHOME=$CDS_ASSURA
#the following line might be completely redundant
export SUBSTRATESTORMHOME=$ASSURAHOME		# For Assura-RF
export LANG=C
export PATH="${PATH}:${CDS_ASSURA}/tools/bin"
export PATH="${PATH}:${CDS_ASSURA}/tools/assura/bin"
export PATH="${PATH}:${SUBSTRATESTORMHOME}/bin"
export ASSURA_AUTO_64BIT=ALL
alias help_cds_assura='$CDS_ASSURA/tools/cdnshelp/bin/cdnshelp &'
# assura
###############################################################################
## /End IC6 Assura Section
###############################################################################
# END_CDS ASSURA

# START_CDS LIBERATE
export ALTOSHOME=$CADHOME/LIBERATE211/.
export PATH="${PATH}:${ALTOSHOME}/bin"
export ALTOS_64=1
export TMPDIR=/tmp
alias help_cds_liberate='$ALTOSHOME/tools/cdnshelp/bin/cdnshelp &'
# liberate, liberate_lv, liberate_mx, variety, lcplot
# END_CDS LIBERATE

# START_CDS INNOVUS
export CDS_INNOVUS=$CADHOME/INNOVUS211/
export PATH="${PATH}:${CDS_INNOVUS}/bin"
alias help_cds_innovus='$CDS_INNOVUS/tools/cdnshelp/bin/cdnshelp &'
# innovus
# END_CDS INNOVUS


# START_CDS SPECTRE
export CDS_SPECTRE=$CADHOME/SPECTRE211/
export PATH="${PATH}:${CDS_SPECTRE}/bin"
alias help_cds_spectre='$CDS_SPECTRE/tools/cdnshelp/bin/cdnshelp &'
# spectre, ultrasim, aps
# END_CDS SPECTRE

# START_CDS GENUS
export CDS_GENUS=$CADHOME/GENUS211
export PATH="${PATH}:${CDS_GENUS}/bin"
alias help_cds_genus='$CDS_GENUS/tools/bin/cdnshelp &'
#END_CDS GENUS
