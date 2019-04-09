odoo10_libs = 'git python2.7 nano virtualenv xz-utils wget fontconfig libfreetype6 libx11-6 libxext6 libxrender1 node-less node-clean-css xfonts-75dpi python-pip gcc python2.7-dev libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libssl-dev libldap2-dev libpq-dev libpng12-dev libjpeg-dev python-setuptools git python-pip python2.7-dev python-setuptools install gcc build-essential libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev libpq-dev libpng12-dev libjpeg-dev poppler-utils node-less node-clean-css build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev libssl-dev libpq-dev python-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev'


odoo10_libs = odoo10_libs.split(' ')
odoo10_libs = list(set(odoo10_libs))
odoo10_libs.sort()
# print(' '.join(odoo10_libs))

# ---------------------------------------
odoo12_libs = 'git python3.5 nano virtualenv  xz-utils wget fontconfig libfreetype6 libx11-6 libxext6 libxrender1  node-less node-clean-css xfonts-75dpi python3-pip gcc python3.5-dev libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libssl-dev libldap2-dev  libpq-dev libpng-dev libjpeg-dev autoconf build-essential fontconfig gcc git idle-python3.5 libevent-dev libfreetype6 libgle3 libjpeg-dev libldap2-dev libpng12-dev libpq-dev libqt4-dbus libqt4-network libqt4-script libqt4-test libqt4-xml libqtcore4 libqtgui4 libsasl2-dev libssl-dev libtool libx11-6 libxext6 libxml2-dev libxrender1 libxslt1-dev nano node-clean-css node-less pkg-config poppler-utils python-dev python-imaging python-opengl python-pip python-pyrex python-pyside.qtopengl python-qt4 python-qt4-gl python-setuptools python3.5 python3.5-dev qt4-designer qt4-dev-tools virtualenv wget xfonts-75dpi xz-utils git python3.5 nano virtualenv  xz-utils wget fontconfig libfreetype6 libx11-6 libxext6 libxrender1 libsass  node-less node-clean-css xfonts-75dpi gcc python3.5-dev libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libssl-dev libldap2-dev  libpq-dev libpng-dev libjpeg-dev'
odoo12_libs = odoo12_libs.split(' ')
odoo12_libs = list(set(odoo12_libs))
odoo12_libs.sort()
print(' '.join(odoo12_libs))