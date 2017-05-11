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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� gY �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq!�DѢ�c8��F~Nsc����V��N��4{��k��P����~�MC{9=��i��>dD\.�&�J�e�5�ߦ��2.�?�Qɿ�Y���T��%	���P�wo{�{�h�\�Z��r�K���l��+�r��4�V�/��5��N�;�����q0Ew�~z-�=�h, � ��/��'�������g�^����c�?��.��.�y��S6�6J���X�$l�sY��|�t|ԧ)��\��(�EQ�'����^������?E���q}���"��RC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ɗ���c�������Eӥ��;���FV�����qu|{��у{���QǞ����)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G���K���Q�S�U�G��?V������_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽OS$y�@�|� �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]>tn��Y���^�湘[��N+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ���S%3��r9!��Y��g���n���P��{��oi&�MI!%i㧃F�s��@[�!j]ꃙm3�i|����$�E�|����Ś����`�~�n3�'0 ������\ג�p5E�̪9�8L�!����S���w�7�����C�U�G)���������h���2P����_���=����1��������_��g��T�_)�����_���O�N����W'�)�-~��); 	h�e0�u(��%�q�#�*���B����Q�E���W.����=q�w4)h��Hc=A]f��\�������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������g��T��������?T���@��W��U���߻��g��T�_
>H���?$����J������ߛ9	�G(L���.@^����`�����%��7kpl�L̇0�н�4��ށ
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��b�.u�A��U;Ǝ�Y�{�u�9Ҷxd\�ǈ�#}/8���sr��8m�<f	��i��� =����4�+qz��	'�h>Cm��LBDy�Z|g����haڳ'�&Te p�� j��a���ЬG����l�]wZ����Ҟ)-K�z��͎���#JH;#)ɜ�H^�n�@B�<�+���z�Z��|����?1���+�/"�ψ����T���W���k�Y����� ��������K��
Ϳ���#�������+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pgX%a	�gQ�%Iʮ��~?�!�����P��W.��S��+��JU,o86'��t�lc�=GZu�-���=yA
/����w�<��i%���䎢�$���x5�`O@��嘱U��v���u{b"�4x6���MF��sJɩ�nV������z~��G�_��������R��O|�)��X��������}}�R�\�8AU��W�o_��.�?�cT%�2��i;����Q�������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���F�u� p�`���m�a}�Z(*e����9��T��|>.X��"�?��%�a��bB��vK#�Ļ���Jw�4Q?_����Є/�u�]q��ϥ��
t��yԘ	��G�׌�8��C0�2�v;Dت�L�5Aut_$�=��z���n|��i;�;�?����R�;�(I<��(��2�I��A���B�D���+����o�(P�e����1��㿟��9+9�Vᯱ�% ��7�g�?�g}��$������7����*-û���֍��{�� �7�ݰ����s��Mk?lڹe�@��S���)�b^<�]h�i���Mb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q�#=�$l��v�$�\h���@8ǻ5u�\�(R�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey����A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`��_����*����?�W��߄ϙ�?ȭ܀�e��U����O%���K�������� ���5��͝dv�
9���D����P�'������7��6��u���>�=n�C�j
��k���m����=8"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B��<���]j�?6�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"���������_:�r���*����?�,����S>c�W����!���������?����_��W��o���:�b�+P}�s)�\��[w�?F!T�Y
*������?�����z��S}�[)���	��i�
���"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q�N���P��_��~t�IU�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^��c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i1��$���}���{�|���lǟ��B�hu�g)��iVh������ (�������P�����R�M#;���&��O��1��t�^���C�P�z�\#W�"�ا����4����\�+�ծj�t����M����`��?����?=}0��u����I|=���)������ֲI�ʭ�����Q���U�r}\����ꝟ���}��\���_V���W�rj�_O���ڕw�m��D��>��/9���[�⶿�k{��ӛ��µo�*�������yZ�.��au[좱��Q�����:��t�!�@t����\�~^,}���"ͮ��(�׊Jr�#��Q����8���G�v��}��]t�~O�u�(޼ZZ���-����`{��ӿ)���ųڋ��=��e҂H��m��7����3�u=p�^��|�imz�k����?�ʾ���~>c�%��rQi�a�������|�o�i������^O�,u�p��l��Be�`�=�ڽV{��D:9*B�GJ��O�����G���-��⶧n��z8e���e.R|Wo�&�U�+�7�H��hȊ��أ�*��o�t�?N6�b�����6���+Ó8[�[;���>[R��É~�dO,�m1��?�㬢ڮ����6�u����r9<.��r�˘�b���u�K��tݺ�t�ֽoJ�=]�n�֞v��5!&��4�o4B�@�D?)����A	$D�`����ж�z��휝����&�t������������y��y0����M���i��������lt1<��d�$3�X�R2��q�ږ�c��'�k ��fz_��	<nuݾ��Ӭ��E��a�{�h6�A�d����&�p�]L��Î��;��$�=�n��Dsp�n�\�wBs�-3���u� �R-�m����L�,��V4]7um����8cg֋���;�$(���d&;�!���d��u�����
_e;R���,��p��>��kƙ����҈y$DfUJ��g�e�hY�}�F����[(-�KC�,��+|��]�=t�q�5FSd9�"l4]�!�[4]h�p�N�f��Ԇӣ��oN��8u�#8���i��N�-����i�=�ɕ������iUu�=�s�g�w�yN��S�9�uPe�!�ЛHҩ���#m��q���YG�Soh���N���.�9�eDi�Թ+�5�{��2�+Q�5N�)F�`t�q9H3����F��ں���]d���TyV�K�R�*6y����U�.r�\�lQ�I�Z;[3��\sB�VWn�3Bs2��#���\���3�:�dT[PNG+�b��9���s�UD�s�I�7m&?�t����08/��f��P�����91��h����Z;��O�}�%a�+#��U{I6ta-�����^��z�}�`�ՙ89���E�t?�}��C�z�@�sy�`��_P>���{��w������Qc����?��������O��8x�Nl�Z{�ߏ��j絖J\x`���.��@�`,��E�U�uc�^�G�׳��V]����*���#��C9=�����Cgoo�vǙ_���ح��wO<����ڥG��9�
<C��B7����9�5�@8�C'��� ��š����9p�q��9���'��\���H�A���>=�Ծ�_���d}����Y�<0"�Ὠ�%�,ף��m��$^�0{����� ��a���6���e�z�����`#G$7C�6�%�n�3�,�Q��!�n�_��[��!��L��P;e��k`�4��Wɝ.��i2_�Q,S�׃�vN6s��x� �8�7s��[�&�<��tw@?�Q�R��p����O�Y:8�.�cJt��'d�>��5�B(���J���*
.2!�ʞZ=��QB�Qʋr˩jK�	I�����	m���2Ų��z)5��I��^
Qx�K�����O�LX�	k3aWa�BO���!a�}6<�����֦���蚝�R3��=`����nUCLpl-��)و�[�]�d ����D`����2���ׯl�L��ITh�[��@kpGBI1&�w8��H�0�ᐕd�&���)�i�A��#ky�<��{�gd��
��D6ar��[E<��*�uвBP��Z�����/�d����ka(FIs�N��{�]��n&�uz;/rA�f�]���w�w_Y�Ǥ,K6`�Q�-wf3��Y.�};�J�`8�N3����=-���b��"�~%�c�TKlR�B�]l��P��2���6u8e���kE����B�
(��}Lϴ�Ԝ����]�,QՃ�|�>��IB��1�U`�@N�0�ՉD�'o�"���2V�9�NTA��-$�R�H͏�L9�+T�n_,!���B��{�,�E��_�,�������D�X�g(ߪpy�$�~	J hb�N
����m0/�W�<��C�a\�孝\;1���l�����0�h�	��%,&kRl���(� �0)W:S�dNY���.U&�	{�>��m�j�O%U��� K���Z�`	!��&�tчn0�fCRw|D��5U�MHy��P��H6)��2H�=�b���,N�g�}6�g[�g�8��>͉�k
j�ͫ���ڕ������X�b�t�������G�ȡ��>�g:3�g����<[9TQw��l�����iC7B׀��^WS�D�g�7?�d������8��J���ɍ;�M�(��浶Z3?ih��TQ����u��@�u�8�ɒl�8��fm2�!��^�?�r��V3�V眅ά]������pCР �Y�V1k�]�_k=���Y�fɌOL�L���@ϝ�qE��bT�3硗!#�b����Dhq���4�	� \m����O������y��Q���u�u�o���_
엂�_
?p�-<���[$��3�.V�|+���le��}�AK	����Xt0�梃Ѡd�AO���`iς�Gu��I���iLWk� �=�w�{�1��7=4E��!�)5�Eҫz؈�EX)�E�@8R����hőh��~����WH�n!8�Ŕ�h^wn�u:�q%_�8Vh�c�rhd�:�����ᑠ�6���ӘI��ݣ&�C�±DM�05:D��g���ꪷC�fj9�i�:F��|>��O(�*q�2��T�q6�AZ��se�u�7�76���6D;�O�bB�%�[$��yյn��i
�$u�-��r�ǥ�V�c<��q8m㰍�6��X׮�t7t��T�2�\�6���c2�c�3���<�{�;t�[�2\��2����}���^���1�������ܗ�ò#i�Hڪ�Hf*8�6J�J)7p�K2�:�e؜�|�����b�KQ���`��>��D�Q�"�Z�QPd�ZS�՟c�w��Fm*	LL);q1D�A0�L��Ni��r&��tP8��Ѳ��/+]n�4��������/
�K)	�bB8Z��썅��Cvc!D����A���0!RcKM���pp�(O���nAy��._ڙ�+�Ŷ;"��|��R<���Byq�Y&�P�l�3� BW��B{���Ė��9@7Y����R.��t���V/�¾K;��a��a���q��q�F�Vr�܇v�fr��Z)$�B�m�"��ۅ�6e5��2m�õ;�-\���n�_G4�JE�5���^�\?C��σ��MqI��&�M����Lw{}�\�W�Uҟ�I�t���^���G~��V�;>��/륧��]_z�/���q�Zc?�������f�ٴp��1�q ���]�Ç���˒�s����Ƀt��7N���_�n<�@���y�__|���?=�^<߉?�u�J��~erEO�ym4��V�6��o�?�'?����n���󯁗����Г��x���HA��v���ޜ�v�jS;mj�M��i6M��v�_q��_q퀴����6�Ӧv�>��������[^F>�C�*W����Y�=�rAl�נ�B'��zl��c&�N�����/�C�MQ^�l�����<�S��)����a�{�38G����Af���צ��,��93v�՞3cO���sfl㰍�2̙9�|�#L��3s.w���Ui��.y�ɜ��/�:h\1�g';��Nvzߦ��_�  