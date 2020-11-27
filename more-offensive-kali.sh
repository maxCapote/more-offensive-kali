#!/bin/bash

# set colors for use throughout the script.
RED="\033[01;31m"
GREEN="\033[01;32m"
YELLOW="\033[01;33m"
BLUE="\033[01;34m"
BOLD="\033[01;01m"
RESET="\033[00m"
export DEBIAN_FRONTEND=noninteractive

# set global install directory
installdir=/opt/

# check if root, if not, exit script.
if (( $EUID != 0 ))
then
    echo -e "\n[${RED}!${RESET}] you are ${RED}not${RESET} root"
    exit
fi

# perform updates so we aren't doing it in every function
echo -e "\n[${GREEN}+${RESET}] performing ${YELLOW}updates${RESET}" && \
    apt-get -qq update

# perform install of common tools so we aren't doing it in (almost) every function
echo -e "\n[${GREEN}+${RESET}] installing common ${YELLOW}system tools${RESET}" && \
    apt-get -qq install -y at yersinia python-dev python3-pip python3-dev pipenv libpcap-dev libnetfilter-queue-dev

# Enables the Root account without a password, needed for some functions. 
echo -e "\n[${GREEN}+${RESET}] installing Root ${YELLOW}Without Password${RESET}" && \
         dpkg-reconfigure kali-grant-root

# Enables SSH to run at startup, needed for Remote Access. 
echo -e "\n[${GREEN}+${RESET}] Enabling SSH ${YELLOW}Access${RESET}" && \
         systemctl enable ssh

# installs Docker
installDocker(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}Docker${RESET}" && \
	apt install -y docker.io && \
        usermod -aG docker $USER  && \
        systemctl enable docker --now
   
}


# update metasploit. Updates for the latest exploits.
metasploitUpdate(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] updateing metasploit ${YELLOW}modules${RESET}" && \
	apt update; apt install metasploit-framework
}

# install PowerSploit. This is a collection of useful pentest powershell modules.
powerSploit(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] downloading ${YELLOW}powersploit${RESET}" && \
	git clone https://github.com/PowerShellMafia/PowerSploit.git
}

# install Ghostpack Compliled Binaries. This is a collection of useful pentest C# Binaries.
ghostpackInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] downloading ${YELLOW}ghostpack${RESET}" && \
        git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git
}

# install Frogger. This is useful for VLAN Hopping.
froggerInstall(){
    cd $installdir && \
        apt-get -qq install -y vlan tshark arp-scan ethtool && \
        echo -e "\n[${GREEN}+${RESET}] downloading ${YELLOW}frogger${RESET}" && \
        git clone https://github.com/nccgroup/vlan-hopping---frogger.git
}

# install Sharpsploit. This is a comoiled version of Sharpploit.
sharpsploitInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] downloading ${YELLOW}sharpsploit${RESET}" && \
        git clone https://github.com/anthemtotheego/SharpSploitConsole.git
}

# install Sparta. Infrastructure Penetration Testing Tool.
spartaInstall(){
    cd $installdir && \
        apt-get -qq install -y python3-pyqt5 hydra cutycapt python-elixir python-qt4 xsltproc python3-sqlalchemy && \
        echo -e "\n[${GREEN}+${RESET}] downloading ${YELLOW}sparta${RESET}" $
        git clone https://github.com/secforce/sparta.git
}


# installs the auto_enumeration script created by Nick and JT. Does a good job of finding open ports and services.
autoenumInstall() {
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] downloading/installing ${YELLOW}auto_enum${RESET}" && \
	apt-get -qq install -y ike-scan dnsutils masscan nbtscan wfuzz && \
	git clone https://github.com/robhughes72/auto_enum.git
}

# installs the password spray script created by Greenwolf.
sprayInstall() {
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] downloading/installing ${YELLOW}spray${RESET}" && \
        git clone https://github.com/Greenwolf/Spray.git
}


# installs SMBMAP. Share Enumeration and Lateral Movement.
smbmapInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}SMBMAP${RESET}" && \
        git clone https://github.com/ShawnDEvans/smbmap.git && \
        cd smbmap && \
        python3 -m pip install -r requirements.txt
}

# installs Nullinux. This will connect to any NULL sessions and enumerate what you need quickly and effectively.
nullinuxInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}NullInux${RESET}" && \
        git clone https://github.com/m8r0wn/nullinux && \
        cd nullinux && \
        bash setup.sh
}

# installs mitm6. IPv6 DNS Poisoning
mitm6Install(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}mitm6${RESET}" && \
        git clone https://github.com/fox-it/mitm6.git && \
        cd mitm6 && \
        python setup.py install && \
        pip install service_identity
}

# installs xrdp. for Desktop Access
xrdpInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}xrdp${RESET}" && \
        apt-get -y install xrdp && \
        systemctl enable xrdp && \
        systemctl enable xrdp-sesman
}


# installs Icebreaker. This is a useful tool that automates some top attacks. Includes installation of Empire, Deathstar, Responder, ridenum, john the ripper, scf attack.
# shouldn't need the libssl installs
iceBreakerInstall(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}icebreaker${RESET}" && \
		git clone --recursive https://github.com/DanMcInerney/icebreaker && \
	cd icebreaker && \
	./setup.sh && \
	pipenv install --three

}

## Icebreaker individual tools
##############################
# Ridenum
installRIDenum(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}RIDenum${RESET}" && \
	git clone https://github.com/trustedsec/ridenum.git && \
	cd ridenum && \
	pipenv install
}

# Powershell Empire
installEmpire(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}Empire${RESET}" && \
	apt install powershell-empire -y 
}

# DeathStar
installDeathStar(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}DeathStar${RESET}" && \
	git clone https://github.com/byt3bl33d3r/DeathStar && \
	cd DeathStar && \
	pipenv install --three
}

# Impacket
installImpacket(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}Impacket${RESET}" && \
	git clone https://github.com/SecureAuthCorp/impacket.git && \
	cd impacket && \
	pipenv install --three
}

# Responder
installResponder(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}Responder${RESET}" && \
	git clone https://github.com/lgandx/Responder.git && \
	cd Responder && \
	pipenv install
}
##############################

# installs testssl.sh. Useful for validating SSL/TLS.
testsslInstall(){
    cd $installdir && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}testssl.sh${RESET}" && \
	apt-get -qq install -y git && \
	git clone https://github.com/drwetter/testssl.sh
}


# installs  users
usersInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing users${YELLOW}file${RESET}" && \
        git clone https://github.com/robhughes72/users.git
}

# installs passwords
passwordsInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing Password${YELLOW}File${RESET}" && \
        git clone https://github.com/robhughes72/passwords.git
}

# installs privesc - selection of priv esc scripts
privInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing Password${YELLOW}File${RESET}" && \
        git clone https://github.com/robhughes72/privesc.git
}

# installs dirsearch
dirsearchInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing dirsearch${YELLOW}file${RESET}" && \
        git clone https://github.com/maurosoria/dirsearch.git 
}

# installs SecLists
seclistsInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing SecLists${YELLOW}file${RESET}" && \
        git clone --depth 1 https://github.com/danielmiessler/SecLists.git 
}

# installs ssh-audit
sshauditInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing SSH${YELLOW}Audit${RESET}" && \
        git clone https://github.com/jtesta/ssh-audit.git 
}

# installs rdp-sec-check
rdpseccheckInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing RDP-SEC-CHECK${YELLOW}2${RESET}" && \
        https://github.com/CiscoCXSecurity/rdp-sec-check.git
}

# installs bettercap 
bettercapInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing${YELLOW}bettercap${RESET}" && \
        apt install bettercap -y
}
 
# installs evil-winrm docker 
evilwinrmInstall(){
    cd $installdir && \ 
        echo -e "\n[${GREEN}+${RESET}] installing evil-winrm${YELLOW}docker${RESET}" && \
        docker pull oscarakaelvis/evil-winrm
}

# installs kadimus LFI scanner
kadimusInstall(){
    cd $installdir && \
        echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}kadimus${RESET}" && \
        apt-get -qq install -y libcurl4-openssl-dev libpcre3-dev libssh-dev && \
        git clone https://github.com/P0cL4bs/Kadimus.git && \
        cd Kadimus && \
        make 
}

# installs Remmina RDP client.
installRemmina(){
    cd $HOME && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}remmina${RESET}" && \
	apt-get -qq install -y remmina
}

# installs NFS tools for mounting network file shares.
installNFStools(){
    cd $HOME && \
	echo -e "\n[${GREEN}+${RESET}] installing ${YELLOW}nfs-common${RESET} and ${YELLOW}cifs-utils${RESET}" && \
	apt-get -qq install -y nfs-common cifs-utils
}





#######################

# display the menu and wait for a choice.
menu(){
    echo -e \
"More Offensive Kali - By Rob Hughes\n\n\
What you want to do?\n\n\
	0 Enable SSH\n\
	1 Install zprezto\n\
	2 Install auto_enumeration\n\
	3 Install CrackMapExec\n\
	4 Install PowerSploit\n\
	5 Install icebreaker\n\
	6 Install Metasploit Framework\n\
	7 Install ssh-audit\n\
	8 Install rdp-sec-check\n\
	9 Install testssl.sh\n\
	10 Install onesixtyone\n\
	11 Install Terminator\n\
	12 Install Remmina\n\
	13 Install nfs-tools\n\
	14 Install FTP client\n\
	15 Install RID enum\n\
	16 Install Empire\n\
	17 Install DeathStar\n\
	18 Install Impacket\n\
	19 Install Responder\n\
	20 Install Covenant\n\
	21 Fuzzbunch Install Instructions\n\
	22 Veil Install Instructions\n\
	23 Install All\n\
	24 Exit\n"
}

if [ "$1" = "full" ]
   then
       installDocker
       metasploitUpdate       
       autoenumInstall
       powerSploit
       ghostpackInstall
       froggerInstall
       spartaInstall
       sharpsploitInstall
       sprayInstall
       smbmapInstall
       nullinuxInstall
       usersInstall
       passwordsInstall
       privInstall
       dirsearchInstall
       seclistsInstall
       sshauditInstall
       rdpseccheckInstall
       mitm6Install
       xrdpInstall
       iceBreakerInstall
       testsslInstall
       installNFStools
       installRemmina
       installRIDenum
       installEmpire
       installDeathStar
       installImpacket
       installResponder
       bettercapInstall
       evilwinrmInstall
       kadimusInstall
else
    while : ;
    do
	menu
	read -rp "Enter choice: " choice
	case $choice in
	    0)enableSSH;;
	    1)installZSH;;
	    2)autoenumInstall;;
	    3)cmeInstall;;
	    4)powerSploit;;
	    5)iceBreakerInstall;;
	    6)metasploitInstall;;
	    7)sshAuditInstall;;
	    8)rdpSecCheckInstall;;
	    9)testsslInstall;;
	    10)onesixtyoneInstall;;
	    11)terminatorInstall;;
	    12)installRemmina;;
	    13)installNFStools;;
	    14)installFTPStuff;;
	    15)installRIDenum;;
	    16)installEmpire;;
	    17)installDeathStar;;
	    18)installImpacket;;
	    19)installResponder;;
	    20)installCovenant;;
	    21)fuzzbunchInstall;;
	    22)installVeil;;
	    23)enableSSH && installZSH && autoenumInstall && cmeInstall && powerSploit && metasploitInstall && iceBreakerInstall && sshAuditInstall && rdpSecCheckInstall && testsslInstall && sslscanInstall && onesixtyoneInstall && terminatorInstall && installNfstools && installFTPStuff && installRemmina && installRIDenum && installEmpire && installDeathStar && installImpacket && installResponder && fuzzbunchInstall && installVeil;;
	    24)clear && break ;;
	    *) echo -e "\n[${RED}!${RESET}]Choice not in list" >&2; exit 2
	esac
    done
fi

