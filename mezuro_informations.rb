module MezuroInformations
  KALIBRO_PROCESSOR = { info: { version: '1.3.2', release: '2' },
                        data: { name: 'kalibro-processor',
                                desc: 'Web service for static source code analysis',
                                labels: ['web service', 'code analysis', 'source code metrics'],
                                licenses: ['AGPL-V3'],
                                vcs_url: 'https://github.com/mezuro/kalibro_processor.git',
                                website_url: 'http://mezuro.org',
                                issue_tracker_url: 'https://github.com/mezuro/kalibro_processor/issues',
                                public_download_numbers: true }
                      }
  KALIBRO_CONFIGURATIONS = { info: { version: '2.1.3', release: '2' },
                             data: { name: 'kalibro-configurations',
                                     desc: 'Web service for managing code analysis configurations',
                                     labels: ['web service', 'source code metrics', 'metric configurations'],
                                     licenses: ['AGPL-V3'],
                                     vcs_url: 'https://github.com/mezuro/kalibro_configurations.git',
                                     website_url: 'http://mezuro.org',
                                     issue_tracker_url: 'https://github.com/mezuro/kalibro_configurations/issues',
                                     public_download_numbers: true }
                           }
  PREZENTO = { info: { version: '1.1.0', release: '1' },
               data: { name: 'prezento',
                       desc: 'Collaborative code metrics',
                       labels: ['web interface', 'source code metrics'],
                       licenses: ['AGPL-V3'],
                       vcs_url: 'https://github.com/mezuro/prezento.git',
                       website_url: 'http://mezuro.org',
                       issue_tracker_url: 'https://github.com/mezuro/prezento/issues',
                       public_download_numbers: true }
             }

  PREZENTO_SPB = PREZENTO.clone
  # Ruby does not have a deep clone method. This is needed so PREZENTO_SPB does not
  # override PREZENTO's data.
  PREZENTO_SPB[:data] = PREZENTO[:data].clone
  PREZENTO_SPB[:data][:name] = 'prezento-spb'
  PREZENTO_SPB[:data][:vcs_url] = 'http://softwarepublico.gov.br/gitlab/mezuro/prezento.git'
  PREZENTO_SPB[:data][:website_url] = 'http://softwarepublico.gov.br/mezuro'
  PREZENTO_SPB[:data][:issue_tracker_url] = 'https://softwarepublico.gov.br/gitlab/mezuro/prezento/issues'
  PREZENTO_SPB[:info] = PREZENTO[:info].clone
  PREZENTO_SPB_EXTRA_RELEASE = '1' # Enables extra releases with fixes relative to the SPB environment. Leave it blank if there are no extra releases.

  PREZENTO_NGINX = { info: { version: '0.0.2', release: '1' },
                     data: { name: 'prezento-nginx',
                             desc: "Mounts Prezento on NGINX's port 80",
                             public_download_numbers: true }
                   }
end
