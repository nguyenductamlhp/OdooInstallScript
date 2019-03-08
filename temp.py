a = 'git python2.7 nano virtualenv xz-utils wget fontconfig libfreetype6 libx11-6 libxext6 libxrender1 node-less node-clean-css xfonts-75dpi python-pip gcc python2.7-dev libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libssl-dev libldap2-dev libpq-dev libpng12-dev libjpeg-dev python-setuptools git python-pip python2.7-dev python-setuptools install gcc build-essential libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev libpq-dev libpng12-dev libjpeg-dev poppler-utils node-less node-clean-css build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev libssl-dev libpq-dev python-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev'


arrs = a.split(' ')
print(len(arrs))
arrs = list(set(arrs))
print(len(arrs))
print(arrs)
arrs.sort()

print(' '.join(arrs))