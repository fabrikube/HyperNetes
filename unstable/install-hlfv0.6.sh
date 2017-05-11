(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� gY �[o�0�yx᥀� �21�BJ�AI`�S��&�Ҳ��}v� !a]�j�$�$r9�o���c��"M;�� B�����H��:�.\va��E�Q�](t�[�BG����J�$�-@-&V��Ӻ���))"|	�/�g")�Q$��!oE}$�� س�H�m����5"�{kE���)��zf�ӄ�^Kh��=f�À���D 4A�v;�42�SL�C~|M�鵬��rh�����Z�G��$(�Ѷ�,ߑr�R{��b"o��ha�`�M(�.���h�M��J��&�sY���h�ɺ>X�H6�qX�^���D���df�?I�v;�H�$~�ɶs+��� E�'����KY���Ÿ��Q�&��1�<1eZ�9���8��	��V����].��qW�*��*
]W���,-�HG_5��O�BO׾%����.�rQ�\FдA#r
A�#`]��A�2�K���x(7[U�ݝ��d�4C�ڮI��NeK_�+(�K�j��<-�����t�괊Cuv3K������ u;�}d�������(�K�lܗZ�P�oy����c��"���}�	o�7����^S�n��m�����4�M�}�ۭ}�m��l�Qy�]78�w��BS�tk�t5|y�K�!�cPY�R�m��ԋUi�`��±����D�O�T$Ϲ���B�s�yS�-��Y!�&�Q�.>|�@�~��g������p8���p8���p8���p8���';2�� (  