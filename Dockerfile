FROM centos:centos7
MAINTAINER rhoerbe <r2h2@hoerbe.at>

RUN yum -y update
RUN yum -y groupinstall "Development Tools" --setopt=group_package_types=mandatory,default,optional
RUN yum -y install epel-release perl-Digest-SHA

RUN yum -y install subversion curl
RUN yum -y install openssl-devel krb5-devel openldap-devel cyrus-sasl-devel readline-devel libffi-devel
RUN yum -y install python-dateutil python-xattr python-twisted python-vobject python-devel python-pip
RUN yum -y install pyOpenSSL python-kerberos python-sqlite3dbm

RUN pip install zodb3 twextpy twisted pycalendar
RUN pip freeze

ADD opt2 /opt2
WORKDIR /opt2
# not using version 6.1, runs into problem "from pycalendar.datetime import DateTime/ImportError: cannot import name DateTime"
RUN svn checkout https://svn.calendarserver.org/repository/calendarserver/CalendarServer/tags/release/CalendarServer-6.0
#RUN ln -s /opt2/CalendarServer-6.0 /opt2/CalendarServer
WORKDIR /opt2/CalendarServer
# run setup only:
RUN /opt2/CalendarServer-6.0/bin/run -s
ADD caldavd-test.plist /opt2/CalendarServer/conf/caldavd-dev.plist
RUN groupadd caldavd
RUN useradd -g caldavd caldavd
ADD start.sh /start.sh
RUN chmod a+x /start.sh
    CMD ["/start.sh"]
# Clean up yum when done.
RUN yum -y clean all

# export persisten storage and logging
VOLUME /opt2/CalendarServer



