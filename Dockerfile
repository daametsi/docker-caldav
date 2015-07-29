FROM centos:centos7
MAINTAINER rhoerbe <r2h2@hoerbe.at>

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install epel-release

RUN yum -y install subversion krb5-devel openssl-devel curl
RUN yum -y install python-dateutil python-xattr python-twisted python-vobject python-devel python-pip
RUN yum -y install pyOpenSSL python-kerberos
RUN yum -y install python-sqlite3dbm
RUN pip freeze

RUN pip install zodb3

RUN mkdir -p /opt2/caldavd && \
    cd /opt2/caldavd && \
    svn checkout https://svn.calendarserver.org/repository/calendarserver/CalendarServer/tags/release/CalendarServer-6.1 && \
    ln -s CalendarServer-6.1 CalendarServer && \
    cd CalendarServer


ADD start.sh /start.sh
RUN chmod a+x /start.sh
    CMD ["/start.sh"]
# Clean up yum when done.
#RUN yum -y clean all





