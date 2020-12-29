#!/bin/bash
#The goal of this exercise is to create a shell script that adds users to the same Linux system as the script is executed on.

# Make sure the script is being executed with superuser privileges.
if [ ${UID} != 0 ]; then
  echo "need sudo privileges!"
  exit 1
else
  echo "running as root"
fi

# Get the username (login).
read -p "Username: " USERNAME

# Get the real name (contents for the description field).
read -p "Name: " NAME

# Get the password.
read -p "Password: " PASSWORD

# Create the user with the password.
useradd -c "${NAME}" -m ${USERNAME}

# Check to see if the useradd command succeeded.
if [ ${?} -eq 0 ]; then echo "user added!"; else
  echo "failed!" exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd ${USERNAME}

# Check to see if the passwd command succeeded.
if [ ${?} -eq 0 ]; then echo "password added!"; else
  echo "failed creating password!"
  exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME}

# Display the username, password, and the host where the user was created.
echo #blank new line
echo "username: ${USERNAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"
