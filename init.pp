class aem_module {
	class {'oracle_java':
		version =>'7u79',
		type => 'jdk',
	}
	user {'aem':
		ensure =>'present',
	}
	file {'/u01':
		ensure =>'directory',
	}
	file {'/u01/author':
		ensure =>'directory',
	}
	exec {'aem':
		command =>"/bin/chown -R aem:aem /u01/author",
		require => File['/u01/author'],
	}
	file {'/tmp/aem_modulefiles':
		ensure =>'directory',
	}
	file {'/tmp/aem_modulefiles/cq-author-p4503.jar':
		source => 'puppet:///modules/aem_module/cq-author-p4503.jar',
	}
	file {'/tmp/aem_modulefiles/aem6-author':
		source => 'puppet:///modules/aem_module/aem6-author',
	}
	file {'/tmp/aem_modulefiles/license.properties':
		source => 'puppet:///modules/aem_module/license.properties',
	}
	exec {'cpcmd':
		path =>["/usr/bin","/usr/sbin","/bin"],
		user => "aem",
		command =>"cp /tmp/aem_modulefiles/cq-author-p4503.jar /u01/author/cq-author-p4503.jar &&cp /tmp/aem_modulefiles/license.properties /u01/author/license.properties && cd /u01/author  && java -jar cq-author-p4503.jar -unpack",
	}
	exec {'cpstrtfile':
		path =>["/ur/bin","/usr/sbin","/bin"],
		user => "root",
		command => "cp /tmp/aem_modulefiles/aem6-author /etc/init.d/",
	}
	file {'/etc/init.d/aem6-author':
		mode => 'a+x',
		owner => "root",
	}
	exec {'sudocmd':
		path =>["/usr/bin","/usr/sbin","/bin"],
		user => "root",
		command => "chkconfig aem6-author on",
	}
	service {'aem6-author':
		ensure => running,
		enable => true,
	}
}
