ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

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

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.1
docker tag hyperledger/composer-playground:0.9.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Y�\Y �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(�%��xl<�$ �ʿڶ#Y <p,���W�M��=��l����2�LQ6�:��5����ƿtGRuh�R���$RmI���ҠҀV�R�4,�v� �W�f��L �Q-CoA��#�
�b�"��R��F6���" x�@+�.�5'e�:�T��e�U�k�nju�f�2�"�BF�n0OH9��pK\��G�-[�������6H�a��h:!z9w����ە��cX+�4Z�o�H�Y�C%d����4�Je��X�R��F�~3F���h[��a��Z$��3�ej0��ZK0<C�$�
y;B�ܔP��[�����mf��`5�\�8�!Kc���㘈rY&:6�U��ч�w1B�	gjU����씷���`���0�����;����#:EQW�^��T�*i3�TQ'(-��K�Pݩ���������W�E]~����	?��p�<s��KZ_���#��oa��툐;!,����yx�O$������C��cc���sJ��G>���J�btuw�
��ۖA�����Y����Fy4 �8��D�[�s��_Ej��Iv����%C@?y
d��QT�B��.)T6�*��rJ|ü���3|�50�
��i���}4X~�B�c��>��{�6���y���?n���$���|��6�;)��bW�X������9l���������_ю��=#Fa�L8��6�fBTH���u�8��IW�����:P3Ll�A��� �mᵗG�i���4:V� ��4kȨ�bk�u��H@��	C�q{h��\.��f�'rSB�Iw�IW���d�%�[��&��jVV�~c�RH�TD7.U'̄$�lJ����G��p����?C�&�����f]k���,��vIt��� ��������/�B�[�I
��W/�¡�ƹ�F��o�r�P{1�C1�41\YR>u��>8�f�'hZ���V���qR��?
Y���A��z���m�ŁӔp�j�l�!�ں���M��َa>}F���"���B�0m:}F�u�k�Ei�_��o_�,u$!��4 ����yK���rh ��4`#z[Ӱ%�-��Ir��**�,\
��]YzW�_�4�Z-@2�:.���߀F���.�$t!��o1��Y�hs�7�m7�x7�uD��� �nh*�w�>P`�=�#�7��q��̦�h/W����(2t�G%��:7}3��ű�U+T�������Jm�!�0튁>{N5��C+�u��AɆ����m�rD���r?���d���ilH{�A�ksF?���z:Pu�m^o~�O/�.�	�����<#,������//�J�ݦy9��������x�ЖdJ1t���?F3��Atg����|b���,�?7���˾��2&�?�7{���]������4����kr ���i�jV�,C�)��f,��*hm��9 ��4��Q�ly�Knf+G�T9[���d��1���VW�V�O��/�1IDQ�#wCH����]�\����..UfO�@ �ں�HI��-\�끃�ϰ�L��9�PP���y��R`��`"�TF�T�r���͉����T������S��R�g#UH���n�Nh��埽aB�o�?!^Y�����7��؂��X�}��Q,�$u�.�ݪA��}ͽ$*)`qZ�&*:ܠ^��A����D�gE�����Ѓ���x&�1�_F��Wq�g�mf���?�I,����B���a��O���\ N��(������y���?���Z�c�lUG�i 2-XW�@G�z3�B�������t�2f��L0|b��9���x�Ä�����A�������0}���-xR�'�!��c��\`h�WīpCGkp�v �,�zLK�oC�Ւt�Sx����?��P��f�!�z$��Il��1v�v``�!D�2p����U"��t��c�ʜ%&S��T�~Ѫt�dJ:��wa1u�L���t��>���5�<����(�BV�<���]�UyY��\��,���t�q�H�O��7w����(�s܂��*�χ��Ŷ�i�H.�jq@�܀ѮsA_� �{�����b�V�G�X�	�a��
5u��1]jo�����o�-<q��E����'�?x�����\����0L��eQH��pK���	�����Y���?x����'��i��f>����A����m�I����G���x�;��+WD�;��_� .��SI�N�nB�$P��o�ba|7+��(����	\��?ӂ���n�fŻjg�n͐%�i�N��rs�5x�ir��f�vn��;t�̓w���x1���ihjFoOR����2��U�'0ɢH���P��̃s�?���)٠��u�⏸�����"]����]�,��au{�2&�l,��Ll!���@�:2��f�=^�h�ģ��
�e,���Zv/�+�50�`̭^8iN�%�r���:J	G�'�䶘^��<�:&s=YX2�#�!WN-BX")�!�!Q"!���BY<*�b�HH��b�"�Ti�*���� �n�$],d������!)�HV�j��m�'�d���d�mqW�^O�ɝ�H���:j����V�HD�WĄ�zw�X��l�ەi�+bj����t����6��]Ui�,���\w�lU��m�VEؚ���>0��h7AH˶�	�� �
t�%�^�Z��|�u�ڸ��f�;�Y�7u�h��Ň�?bÅ��|��?�7�?�+H�h�W�3��\B
��qz@v��z��ٿ� Lu�Xe�
�2�l������ b��L�Y����<�w�z<������������������c0m���R�I��s���h����u����� �=Կ�xtR�i�7���t"����@��f0�[.6A���5zy%�;jd��\��G���;�:�����G�V���R���lD�����>\��~s���^���U��4)�,� ����ɼ��oP�і�JmL���Z��ͥ������H,�����'+�䖪��h:������GM���|F���mOZ�%���|�A�\,�/�s����{��aZ/wh��,�d����V�kT/���� ȏ��1B�gG�žs�w�8���Ǽ��Gf�>���})\�S���+�.�s+�ϫ�6\���E��a����wD�>�2�5�O2�=�!���{!�:]�/1�ޭ�굚��<ī��k�	�Pt��Z����d���_6]��1���]q7S���Y��|�����4M�84��,�-����;o���OQ�������8�f|AKu4晴{�;�b���5�,S�h|8á��;�Vx5�%���C(�h�����R�q1��R|��K+l4.���D�z����1���c+,��u��*\EE�~n�hB1��E��eh9j]����tCR�d� %��ٍlJ��$�P�e����TJP2��M
�l)�[�ovv�WE���ߪ7y�y.l%����q�X*���d7W���z����-�2b���ιX͡�vGL%s[%nÖ�:r�7���^.Y"qɳ\~��hgŃޡ���K��ǵs� �����\�}��*�3��9Ӷ[�N�z�#��8�c���e����;Ξ厅^�z ���&�a����\x�l�w��~U�v��r�+�5ˊ]3��wf�V{���̕�����lu/�8����f��7e.�ɕW��n�t:y�<Ȱf�$��A>�n�����n-����V���IW��o�[�A���I	�����Jr���t;_�m�$�5E�Ի�וͭ�N��rp� ��w_����XJ��[���ڕ#�v"�9�����Ύ=(T�S�:��'ۭN\ʫ���M7�e�x���HR@���k�9��ʫR)��L*eg�����dN�8�+&#�R*'ݭ�~�PG�'S�n���u�{��)+q�x�����w6_�H�UP�.�ᥓJ�h�Tí����-���.w�nY�6j�閱em��KFW��	���le�6Q9����UmU>���ʦ�꡾S.M&�yu4e�9_=;��؈K�W�S=�9�dΙD�s�6��1�A_\\ܷ�Z���p$�鶡7�U�}������eX�n_d�*�����D� ���0���&���������!���}�}���	�?����(�-��t�b9��&}�%��GT.������d�4S��V�o��x�]q3�a�֗K�F��~��I)�Qv�bǏ(�hl�W^��+Ǌ���W�+ԥ��^�,�S�P*��W�^I�L��9���JV6����b;�(>V�w�򺑭��R�3����r�c��<T$�˗+�r�o粯":�Km)b>�|�f�b���|�lt����<����v�������ύ�����@p��IngS���3�����df6ǔ�׃�0e��j?�����̰s6e��?����nq��|��է�;jﳇ_��_�����ҟ�=��O�(�J]�y�y&��k��s	)��x��`clT�Kr���L-��+0*�������� �����r���o�����_���������=�7�b�W��yH]�TXzF�D0M��UC_�r�'ԏV��U�K�,��%MQ)C��Qۭ�?[Z���G���/�铥��d0˳�>�g��K�Gd'�^�b�?�t�����!���:�O��d�����qe�/��y�x9LC�R����������?���>��o����o�꟟�����x?Er�|ޠ�g��\0���lt����.��xO;��en��l�R|"z�)�=#}�A�����ѣ���4)�{ѬG�#G�f��1	+byW,㯼�����.�Ii����g���p����!��H|m&R����j#b ��(�����fx{��'!})�|��IR�O�rP�0����,�:�$�$q�(���)�z���b�(qq��>����F�7� ������mFj~�t�~���GIWω �G����$�q�:{�ɤ�3=�(����L�遅n"E5��p%Q��E���*REQ*J:�!�����࣓��	Āa�	�� 9�=r��CJ�*UI�tWw�<�W@u�����������h���mV���}��@?<'oɋ�V�h�bx��-�W���Y��lUbX)�8���YN6,{5��>q.f+�
[Y��x��>=���;�W.���̣Ez���by�Z��x
�#?���#�X�~����Nl�N4Y��`�yT]�P��+��4ύ'�Cp5ʋD����Ǧ;zx�c���qG���D_���d���ɪ]���J?���M���)��#v���*X���BX_ǹ����r��C��ko�(��}�qp�}WW�����e7F�c$Y�۟x���{�2�����5~a�$=��.MZ.y֍~/�9� dq�.��
]e.�s��g��¬��JW+�"W#���5�<;���c�`Β\��Y��$駶���Q�A.�ƋNr��ղ��`zY�Ɠ�v�x�'�?��	~$��N�b�ƕ$��4�~����NZ��������f�4�BUV�C��*�����?:6{�:���C���se�T��o�TH���GtR��P����:]`��MW�;��b.,Gdn�ga�\��5;�'���bf�����+�>ӋO�M�.�ړE����	��즓X��_Z���Ŵ���ǆ��Pn3b������fZ��6��2p�'w*v[P��ץ���Y��I������}�����jP^~�������q���n���������~%�w���+���_}�~��?���?�x���ߤS�V~T~Pf�o���K����W�X�kI��Bi��?�qT���CGM,��M�ng�v�me3(l�N������X�Y�2�&��S�֥?���~�����?��o������?|��/}��*�?+�RR�� x�4X�~�~���E���S�~�4��������?��ԏ�J��[���%��@�,34MZ�qj�D��P� Q�B���A��'ɛ����`�2 ��e�oG�UU��sRZ��:
ݭtt����Ҥ�`�y��/�
���\��~~�!���SN!�K_a�ܬ5g'�f��7��%c��@k<��:FEP���g�R���4�ϼ�g��gI��M��$��&���v&�uYr
	I��bh����t_UʦS�L^r"�_�'��L�4c�a��vxr�dl����3�Pr�fT+a-�yA��a[
��B2�H�e��ɜSC�l%�_��,�"�H��$@9Έr�<%��X[0IE�K)$��twyAGt)�v�mnς������ح�y�0�i��8���4��"s��N�H2T�tYrD�5ZCt ����Z�:��j#���%��h1T$�+�Ki����-~D
�J[z��";6�L��L���|D��&�ƲI}����ғU%��U����
b�$��R��hpj��.d�<�a�K�U<6ZȰ���#Ab#&Z墓�h5ԙ�Hs)�K6c���v�;T8�� �I�\��՞>�sz���>8�0��Q�B�ju��A7r����|Gf�Ja�J/�"��U��zyQ �D(hR$���T�(�����D�`�U�Hf��mb��*�@-�,F�&Pm�<��E{��w�Q�&!��:]$'\���i��$��	�Ҽ�t��2���p��&�K$��P2�Iwje�G�-�+�'�r����,����Y"��G;�	�u ������,��[Z���Y�tPչ�vD�ͬh
�JM�ކS�QY�Yt�<�(��mp����3����	)�5l�xN`5�A�E���چ��c>�{��F���ST��y:<�� ��s�� @h�|%Ö�B���2���:��*�Ԉ�rn��Ŗ5�*�+��aiҹLX���J}}�Rক<�My���� 7-�nZ�ܴ��ip��<�Mx����\�X�7�����^I~c��j+�=�t+��S�x�R��A��ߟ9���k����<>9>������k'�[�PO<�ӛ�_�&�;��|�tO�Go~���x��^���Rr����ƻ4?g�WQ�PR:�QNc�Sx��@;1ދ�1�7����^�x�`��&e|MiR x9/���� �Y��Ru�_ˎ˃�Fe(�|�&�b�(�<q#q4��	W��Ś�L�\_)�Jcƪʷa�S���k���l�� s�ar=�Pjy�B6�զv~j�4�o��xgI�B�~�Wd)������W��k����m�a�)�z����X�t�f�5�k�e��Y&�\���sQ�Y��a���%=�0��%�&��l�ȕ2n�ى��B�*v�鎪��S�X�<7�N�p���8e�i�����z��U;ʀX6#��=�����8R�y���h�����5%����`P�e��b�.�2�>8 %3D�44�YC�գ�Ǩ�М�l�����*��,53�C���a�QlG}Qa2~��h�����s�*�E�`�b5�Jo*�uS�e�J��j�g�Z��tu�$;��b�'U��S�Xd��=���e����q�A���,�v���ϧ�����':�������?O�~� �������?Xj��>H�̓�7�9��+!���|fp���TuG-��ғ��"BQ΄���=kŝgH�Xq�ȹ�(��,�.�OPxbX��:� O+��=��h+T<�%T,�71
��Z�X�w�:r����xKb�ё3#���N�KzMT�;���k����s�#��h$9]�:���)Ԧ����7�X-r�>:�nP}���d5� K�8�m-�.n��bw����o���?�(J�b�a�K���@��bܙ�Å�3l�<@{ݢ�!M�V�:��ZDؖ'�>u:��i=�c 72�%��c ��b�,ceg��ZH#�)�.D!h-1P�Pd��AS$An��1�����Q=(��2���A�:�hT�&Zѭ�e�dn��1���xɷ����~��K�%yoM����n�Y�I��	l��u 0�8V^R��?I������u ��T�NW���H��B:�Y�詜G#����.�E�1��Z~T��dLU;+���\E	���&���N�`�|�G,DD'����l�MV��x����F�D��M��%e6��t��@�JOke\OQ#�)w5����U��UW�̠Xw��S	K�h�����X9�G�!X�0Ocx�}�R���s��U��s��9��/�>�>Z�{�G�>cѪ���~�����_�����5V�Nk�
��ѐI c$�6!��5��q?���pf�8�ymDN�	B�j��
g0f���*1�Z�q���A���~8�J�cF��ka0ke���kXP�7,�m�%�1S����<�ق�y?��e�!�Tf�^GRaII��:<^]���b5c-� L�=p>�W{�
��e�;�	�X����X���5�nz�F�6D��v=��-ԥ�tv�P#�[NĽzKe�¨Җ¶^�5�%� B\y8��1jň����R5S�XP@G�`H�D�7/�+\�DO����t�R�p-��F������I���럄��@�}�ID�_XE4%+��E��0up�x�+��$G���P��ԛ�W��C�����J��FGv�V��k���|�=��O>��v��<ʲiw��S?�,�A��X�{��;突�y���s��k<�����j��/_��<\��s�e��E�;���7c=�q�s����O����ى?�����L{�^� �GcQ{���Ob��	;����4GVZa��R���۪��"�g>���A8 >��yQ�)����M\�O��;���}��۠��f�̖{<���� ���z��Q6�4����۠;���7��A���A��/k5w�=���nc���q���m�]����?�E��t[�A�����O{������F7�?���۠���]�o�!��������?�l��=����_��}|a��]�g�n�/��g����}��[�}��Q��p��(�z�>���%�����A;�������)�����������������]��1���������u1��g�����ѝ�����,����۠�ɫ+��������;����?�=�����ΰ�<g���7�|���]���X�S��\��
u�6ㆴ��}F������@AǾ}c�_�#'�����>>���A�:�'�QN��a
���KP�r�V�� :o�ZD�6���&�w�^_�I-3�G^ؑ�Q�K7�bd7�����Lw`[{�'��i��ǣ�:�q�;*8����������(�nY/(�邍���3���|�A:Q�NQ�D����
9��ÎXt�&pm�5��8i���K�4'g n6\���
҂�/뎲�����N�����e���w�c��k�±?�����h������]������]��0s6Y:L�(�������e�x�PH�m��1P��Q�ε!׳���ep�l�&�8|^��٦���(o������Z��kRQ�=��<���\!�:��v�)��Il@���ѫͥ��*t�? �b2��5�U? ���*s���!ݑ��"b�1h���X���0vR�9�s�lf� ����;�&E�,
��+�݈�yx�DET@&_:U�PT�_�Zýu�ޚ��s�rU&��J�b�}�Y�(/M7� ��v�͢����ݹ>�{V�S�f���l0������{zS�?p����O��������?����K��g�Ɂ�k,�_������FhD�aU[�����~����{{`��a��a��7��"�N��������$:�8&c����$�r*r*�蘹���4��\�#����#h�8��W�
��W����3�غ�*M�-b�!=ns.����Ul��wm�[����w�S�Eܞ],�\�W&T/{��f@,�Ò���RH�bp�)����'�vb.��U�>�^��*���6_��U�����?�>�H��j����MU� �4q������?��������f�b�q������������?�|cES�����,��&��o����o��F{���/���L�1߸��}�8�?�j�/�7B���d���
�?Jp���+��ߍ���ď�o�S�W}�bk�4��4۔ŏλ��b�V���?���n�6��zTh��i�������\k�Z���&f�w�>������ W�v'��={YNuZV��er8���:>v�x��]�Rl1�¸^�������U��f�G�NW���]��:�W(������}S��wW.��69V�P�v��ɲ){6i[۶B�ԣ�D��FmS��!=��BS��_��k�1�J>�v��\�A �T�ЭN̬�q�fC�+Lx}�ˊ{�@�c�v��V������ތ�GC����=ǒ�B��ҵ��}�R���_�@\�A��W���C�� ������?���?����h����������?�������N�=_���,���`��U�G��m[�mNyy�a�J�=�SN�[Q�K�z�L�����CcAF��wV^sb?������U���M͟�a�&oy��]O����/��c��w`e�.��ߺ���ͭ�$��6y�{�)�7�B�>����<p�}�d.ʀR�X_
���f^��c���$/;����?���T4S��1��?���A���Wt4����8�X�A����������?/�?��4��?�O�㛢~��k���?��9���������O��	����7���Ԁ���#��y���	�?"�����/���o|�VQД������ ����������CP�A0 b������ga���?�D������?������?�lF���]�a����@�C#`���/�>����g9�I�y��j�o������Ɵ�ߘ�Yg6�Z�9�=��E���?���?7�sP���uRt�Y|����Qg��=Ic�'���9���L�WlG�/C"2F�����+�SS[ӣC���؜�vՒ.Z���:��r�l��e���_x���n�?{|U�༿����^.d��T:�)�lev�o􏇛w0��`u*�,%mڦp���޸���Yh��V���@�TfQ�Ju��E8�Y�.��O�k�j�B ;�B����p�a���EZ:v�{����N9k�1f��E�=��W����g�&@\���ku�2��� ����?��y����p����r!��<�������҂(r\������H�S"˦�(�,˱�D�C��z����78�?s7�O�σ�o�/����{w��/C?��ww���V����Go���kylx�r��a��q���k�.f����|�XO��raˣ�,�^�PXeXus{<��6�z�
q����rLȋe�/'�Н�r�M�E$h�Z�_&��If_І5��X�����=�)�8f�����t4���� �;px���C���@������������G�a�8����t�����`��@������Ā�������D���#�������������������������B�!�����������Y�~��|���#�C�����g񽳷L����|�������8?|3���o&�����x�Hκ5y�d�,������,��v�����kf����<��Q��ڛ��Yk�V_�K5�/�l#]��za�aݕ?|����4��9ao�x3*zt6m��}�Ǫ�̔�N��J��e���Ч�XwO!-����G|�td���0'�5�5�4r��J��t��u8=�?�eMg�q����C�<��c�ʲN�ۡ���-��۪pݒ���[��s|2Z7g>-M]����'��	���p����ux��e��9*]�����+�\����'�1e�6�P%�ߥP:V����ݒ>��j��2�_O����۹���0^��}梕3�mv4��O]%ծ�ږ��X�;��=��Nn�e �SA7�u��U.��r-%��$�N_妄k[��l��q��M��s�dI!F��z���)�Ͽ���n��� ���?��@���]������\�_"i:�*ɲ4�i6ʙ,⥘�D�ᓄgi�Is>�$��h>gE�f�$Ob*�3	�?~��?��+�?r������ق8��Ó8��"��0��?�#�%^?�Xc�T����vgmUI�I��[uƺ�N8/����T�>�}��Z��|(��,����v����A{{���)j������?�����������	p���W�?0��o������q����3��@�� ���/t4������(�����#���Bb���/Ā���#��i�������=���+�4 7GS�����M��r1�]6;���,��4`�����{��.�t���S���-q�8�NG��� ����k��Y͜��l�|�媥�e�L�j�V]�?O�۸c�u�u��t[�6��Q�ߎ׬������֦��҃�b��]���%������%	�����<��ԙ�'b������XS���cY2]�J�EκQJ���D��FY���{�ӝc���3�H���2aG�2Vμ�o���?��q��_�����?,�򿐁����G��U�C��o�o������1���E6����?�~`�$������=]�[��7��닾#�K݅�@!	�����q�&U	�l���f"�YA��Q�P�0�+kL/��sZ���VFӓ>`]k�O������<ߢK���/E�z[Y�i�����z�YAMe��ц��{ɫ#���_=YU4y���n�9vM����滍��F���@����t���j;>����y�/S��Ү#�^�����V,�5iC�[��k�����ߥQ�E��_�@\�A�b��������/d`���/�>����g9�������[����N�/����[�4_Z�|�J��P����ǿ���B~��~�{뤐O_���W=~w��RYZ�rf�cW��M&,����epȧ[�= ��<���p��m
R������u�F֯���j�դL��u�:EX(������www����>�����^.d��T:��.��Z�C�#�j�g���A<�fd��z3�L%�)��A�U39u�8`�׉�{��ӎL�eSs;}�Cw'R��6���f���3�0ҋv93�����˼\�uN�Y�2g!"[ӽ�:�Y���Cnݪ�K.�-J-�Jte�T�6��������/d �� �1���w����C�:p��J*O�!9��DLQ���(��Ȍ�D&�IA��/�|D�t��#�<$�~��U��5¯��*֫�-�Ex�egA����=�q)�g��9�vZ�s���ݩ5�)�t�[c����h��kӉ��n��t�
W�����8�Ƴ�$_)��z���vijb8럒�<2��Y���������X����ߍ����D`����3�����5�/O�O��w#4�����-M����S��&��o����o����?��ެ�cy6�82Ϥ8�2!%�OҜ�R*�RV�9I�96!91a8�g(!�.��4�S>���������� ��~e���7�s�+I��1��C?v:�m���V�o�y<���K���^ר:U����[��b�i����+Z�2;�X�{tN72����e�î���W�b�u5��ϳ��YQբ�F{�����}���0��o����� li���L������!���?�|�
�?�?j����? �����Ɗ���G�Y8�� ��!��ў�����_#4S�A�7�������?��Y�ۏ8��W��,��	`��a��Ѯ���7*��� �W���������Ѵ�C /���o����?����p�+*�������^�����ρ�o��&_��3��MД�����j@�A���?�<� ����6#�����/�������XDAS������5������������A����}�X�?���D���#��������������_P�!��`c0b�������������C.8p����9��n����o����o�����/p�c# ��Vٵ:��D������P/����7.��E�Ȥigy�ё�K��e\,r'�	�1�$l������Yl&�+�b���������O=� ��	�������ο-�����<ה��4+:YG�ހeͥ�j����wemj�[��_�~Υ���E_0�ʠ��p��������N*ѓ��$���]y�H*����޽�ھ�aփ��I�DCO'�#�����)V~��4X�g�s�N&�?s6��)[!��8���F�"�J����HFcͭp���3�1������疹����QL��Z$_m�ݓj���p���������+
�?:�.����k�����Z����2 ��o��A�Gk���֟6Ѕ�0�������?`�� �ׂ��-��ϭ�:�� ��5t����o	��n��������@����@�G� ��s�N�?��h�����s�?�.�������o��\���P�񲒋B�Kp��Io�Y ���?� �������K{���As�,���ؓN�!I�&��o%	r�V�]
}0��ܛ`ʄw9�661��v7��4m̚�2v����ׯh�%�Q��1�����)	W��b�(U[\�i��̥���4cdA.i�)�|�OZ��>f�Z����������k�!tB�����в��-��ϭ���� ��=t����O�}�gũ��b����H<&c��a�=,B��yᡱQaL�=<FA�ǯ���?�����@f[^q�k�s�Gw�B0���)�.�+��)l�Yگ�/�v�lut&���呇	P��c�u܇�P2�ݠ��Ov�|�&}cK;%1�{����cZ���4��5�'���|��������������q�&�'���>~A��x���~��������7�.�?������i|�#�#��0t@�}:b�D�>��c,����SW��`(���	$�h����A��D����?�h����y^�⹚d	�m�p�ɐ�QoL\���*�vCr�z�4lL��z�a����l���y��?��b��$H�:¡L�{#Ƀ��+1��?���6\��:%��E��BӁ��(�p�G��_p�������]4u��a�}���翍��/M��_�Fܤ*����H)��L����r��=�5X�u��Ǿk�2�ZL��ĺ�g���=_�sz���J��ۖ/�ͷ&���^Z��*7zmYS��T�g��ॳn�}��S9�~_@���+j��{a'��������Ԓ����Q-��x�=�^����8}>���Z�����z� ����)���f�tB%zB�*�����N�|�2�g0��,M�tV,��+�
��¾��)������l�P��0���b33�Y͂b�C�j.V�h{
KV�
�Ux4ې�j3�l
�ޏ��3J5_��m�]�^R}�^�?���r���M ���	tB�S�?�hM|�A�ow������C�����uM������ �������'�������{p˜�	��>��?��g�����ľ��^w~8��g��l�E�r�n����0-v�X��)O��,���A�5-���_0e
�Jd��)Y���FDs#�y�)_f��ɸ�A��`+����s.
�3�oc|Է1>lƲ�m��EF����̎&EE��:U+�r�OVS��bE��՚qF�lb�u����f�<L�������UE��y��Oy�GW���M0��]KȆ{�3J�W.�ŌMYj���vN5
$]`�"CVlL��$�*�77;n����3�＇.�?��|��A�o#h��B~���?����������>A�	��V%�����!���&�������7�g�__�%w^_����2�mu}�]�*ȟ�w���^�w���Z���)mw�|�w{5�/�7��.kȵ����#| �V�B ��t7�0��d2fe�7'+����d�>������:�ϭ�T�&���+|�4��,�DK[ T�3+�^�4^�mF*��|/���s���L8��r��p����9H*���i��1��Q9����o�}���WC�\������?^�
��ww��/҅�HzJIk�IK�MEڙ���C~���1����e��)6��WCSg�L�hF�D��?:��
����V��~����������k��L��Ӎ�3	�^%հ�5U�r'he�����wum�����w}@+)��Z�Si0���L	���FR'�yP��ZJS�,���_��#bt�����g}	+ٰ�&Z9-cY5yy�E��T��;{�T
h��b�x�0a|*Ғ�I�����Q�w��a�
��}�����C�k�d~J�5�a�,�/c��+���B6�2"?�c��
�\��U�Ȅ��2w�ġp��b�mN9r��w�@��נ����@���_`������������FФ�������Q����{�� ����ٛ1��V��%w�t+�d�~��	luUV�*X�L�1��o��D((^s����؇���b�ùg�C�d0,�mi;���ؕ��Q�p��<g(#8Y�8B�������������c��@fv��ÚY���Pgwu���]�7F�ԁu~�HӘ�O;3�M	2�V�K��̪�D�k���;�7W}3!���p��cg��ʞg	Q�$��tOH2s���7 ����������@�u]��h�?6���@�����������/8l]�`��=����7�|��9����x$�Q�"��[�r�1-`C�.	j�5�/h=�E�;��C7�P�Df1�,�2g+���%�sww���/�ܹ��T�\�dI�iɪ�R�Ś�����ﻋ���_��+P�nP�_�����m^2���vF��Z]������/�d1��'n�r{y"�4:_�U���F���;�M��z�[tA�]��������i�;
����_�Cp��[B��*@]C�?���P��P���V�����$�M�O����K��,��x�����͠�O��R��	4��wk��# ���m������������ ���u������_C� ���`�h����w�P�k������`��&��	� ����_'�{�����m��] ������������פ�3�� ���[�u������������9@�������&����0y���
���-ssx$d�
+���O���������ؗL3n����s��뜠�{�(S���R�Q�����5�@��b�eն<���e��2���A�T�l>%���ވh��c�>�6���,�9�<X�4�
�����sQ��,�]㤾]��f,���k�Y��2;���C�T���e>YM5
�)�Wk�ͳ�=�5��G������UE��y��Oy�GW���M0��]KȆ{�3J�W.�ŌMYj���vN5
$]`�"CVlL��$�*�77;n����3����	��<�󿍠-��G���#`�����[�u���G�����F�:�G11L�1C�NP��4s���OR��Q�t�� �ȫ5$��#��{x��������z��$��M����#��~�Ȣ�����Պr?J��$��ng���)L���.�z�0��z�"��)��L�MS�sg���`o�k3���(�s��2�������jV6��T:"hOQ��e��:�-X�nfg|�F������Is��ʜ�r��h_m�ݓj���p�G�;����O������Q4�����Cq���@'������4�����7��N�?����C���O#h��AT� ���u�'�����gC�
��.�v���l�'
�?� ���O��	�?���|p����U�B�Z���[�u������&�	���5t��?��P��� ��O �	�?�[����?7�V��j��n��	�'����������(8	h���W����[������W��]\�$ZϜ=[Y:��>����������^���v��*X[ge��S�W��_^D�՟_P����AOXW�'�4�m/�*�)���ѐ��eAEܖVF�ʒ�1s2զPeK�c���î��m��玡��7m�N�BKU����ɲOo��cu�M��֕ �j�c]W�K�����W_b�z���4��WG.?������j��,>���#��Ә���l���p)��8/��c��Y���N��#��Jf^&��+	& ���b���!1_����R�M{�"N>���:�����V��j��n������`��t��#�#����b4�c$�P1ڏI*�I��F�.��RX�(N1a��$��_E��Q���a�����B�>\�M�7�EeA �9���Ď*�MT��P*i��{/�O����ո�(�9^$~�#I�u���O�P�#�d4��tt^�39"��:N�7|��.��ı��:�VcW����?}���>%��鑿�����|�Q�����hp����_��n`�+��/�)��l7_�t_V_��~���/�}���x�՗+���MX��Q�������l1�dW��lf{���vg҈`Z��d��ʮr90���\~�ˏ�z��vU�e�l�V�$��"-�$H���DHbE�h���@ �$��|�!��V

Uv�������>����.�{�[�ι��sν���J;6��1u<�!�fu5��3@��;/܊�Z,�+����/����'T$�b>���Wvbۉݸ�-�
{�&/����R> h��Շ��
b���H��8wf�^Ls睶{��Z�����p����Ӈ=]3�al)��[HH�f9�v�K�����;���q,ǌ��Q�j����|�����G�,A�� �xO,pLE��jOFwr���>�5��7���'����{�ֆ���z8����(������AW�Wۡ*<s��0��R�"J�P-�wC�W;G0�"�R�rUB�ߍ�#5�9�N��{�N u�^�-������ĝ�������o���ȏ�h"v[��g���=6���2��WhwFӐE�rND�R��t�O(;z���R�i��1G�t'\��9A����ݚc�?���O"������ThӇxprc��G ޸ ^�����>������\Z�ċ/����������jFO#IEok��,�"X�X�5�P�6j��6�Pq=�b(��8OFa\������g���o>���~�ן�߿�+?<���
��y����M�
�1p�𼞥.��6t<�����x�e;TT��'Ok܇~��Ua!��_9����]N�����v��Ņ��U虭��~�|X�T}h�s�=]	+/�
�:^W�Cu{/��p�C���l��?�����/��ӟ|���o�ϭ��w�k��W�KQ�\�����;x�������;�o��	�1�؃�ASp�����F�� ;۱K/���/��v_��֧��_����;���{ov��4��Q��$�]	�)���ֹ��¹��_���#���k9���K�lj8c�j;���4����6����SIXkcm<�$RXZE�n��4��S��5�J�u������o+��?��︿�{��\���o�1�����}�&�| ,>���7N���}�ځ���������zz�9��;���Ň���(^���U�����Q�״>6��6�cqp�~�q�H4���L.3k͙���5n�N@
��̉jP�3N,�-!���^��2� W�j�1AQ��ȅ��"9��d}�ޚ�}�k�L�#k�G�re	ɎA�i͚u�Ve�=gZ�.w�Z��'�Gs�W8Ĕ����N�8��7_��d
����e�T_K�Y�yt�7���%e���jb���F'�a��2�=����!>��R����r�z
?��tN�8Oz6�Z����D�4�� G6�W�7Г"AG�w��.;4kIQVI�ae6�hi �ݲњ�+�fL���h����f)�b�����(|_.4�%,��&�D�`�v˃�45�� �h��E�ϔ�_�i���U�xj�&;h�C��$*������@�����<��҄�k�C�=��"ۑT��R���r�<&A̜�9_2BԜ�S��&V<���v�����e6!r�޶��$��V]��W�g�"�h�j�R+�[��C��A$J��P�GT��R���%M{�����l���n`r~|�Kf;��#�{Y �([���M ���hFLA����-*$�d���|\�a�U�ל8	��('(����q����_hr�BE>��w�88n�$8F�
�8��Β�L�A�p|���ɖG���h�r�t����ш��'�<^��ݩ��OT��I�k�Kuʭ��B�@lK���L�w�Y���,g�r���+MfY3�j���:d]0���rW��5yn²P�F��:yF&�Լ���T�eoT�N�%�%��P4˱R˛��f�Y�Z���F��qL�j ��8�&�ӫc�#ȇpOe��0E�Xc��y��'z�sꊛ�|�'ƹ�+��R����Yfs�!������E�������~�%u��`�rg�E�b�����Y;ڷ���׵�\���)V�Am�FMt�Gf�P�Ez�8�.�s��Qt8��(9l��'���6��������gش�ϰ	i�NO�cG�����qYhg�dy��z9#B��OR^��يN��
���I֑��q���0i�p�oK��lU�9E(�����S籁��l�����\����` �֫����'���Ê5��U�B����Y	�'���D�l3�e��1W�%�j�51�cs�,��N7�^F��D�*Ш$�V��I19�ilb���ى/認+���&�y"�<@X�g��B�@�����[��$����\�"�mA���[Ol_��{���Z߄~>D��Z�+k�h�pp��5��n��R��홃5�w����������KW�?�rP�p㝟1�+�d�(vt1��f}�X�M?��0�g1ޏ!}Ќw�,��1�3hR�m�28;c�Z�4�`?�n��6ݯ�G�n'��'�l����
�al���S�q���jզ9��Xd�����5���̉�T�ڻ���!`nԵ\�[6,���ͩ��~9�i7����D�U��-| ��&�n_n�,���V��ݡؑ��T�f��m�욍��auF�
�${���M�C�\��(�q��=fK�f~���z���t�SV�~_T�C�q�b�!}@U쩩�T���\�L7��I�%�a0���֤V+H���+c�t��	��Z����D��+�^V42sK������K�力廰L��㎃5?	;���z3#Y��s\c�6��0��U,�rjTŽ��r�J����H��Ac�y�,>�M��a�@�rYo��ޔw%Mt�B�"�`��"��r�j�E�̿k*yT�����b���9j�u_�-ש�=K�A�COo]����r��JG��n��"&��.��[ �}������ͥ�~�&�7���<T���N1��'6�OlN�8�_����K�H?���%Y{����C��(�@�4yD[}] M�V{���dÅI8�L'��Ov%��K��q�Pn!��l��SS!� j��s�m~^S�Z����H]�թld`3\Vn��$.<�߄���x2 SFeC=��|�w|}�s�1���I�����{~��o������'tw�3�-����e�r���nS�����Zu��,�.?n��bs8tYE�i=�����+(j7i���n�L��s��K�M�c���9~j�o��?o�U?aުM�p=<{����7�z��Ջ��_�8Օ�<�2ނ>�u�^�2>=���[o���<{#d�=s��G����<����ؑm�#n�"���?�ř�CW���I����)��He�vk�C�A�������_�?��������x����&�+_������^�٧ϵ#��k8��~4y��"x��we�gi����[������D�tC�N�"����}|d�7�����h8V��!��~³+t\�{?��u��}�h\?m��c'��"�xb���l`��6��l`��O2�?
E� � 