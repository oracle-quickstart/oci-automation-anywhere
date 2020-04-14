#!/usr/bin/env bash

cd ~opc

# Normal box urls expire after use
#wget -O AutomationAnywhereEnterprise_A2019_el7.bin 'https://public.boxcloud.com/d/1/......'
# page doesn't redirect
# curl https://automationanywhere-support.app.box.com/s/9tx948vtyi9qsxn2cr5k1en5ntgvd5ed/file/643956731765

# add sensible retry flags?
wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/Fl_8n_q4zz_477PMI31mol6CquUCyujMFL6dhHDRETU/n/idmmwyjidb5r/b/installers/o/AutomationAnywhereEnterprise_A2019_el7.bin
