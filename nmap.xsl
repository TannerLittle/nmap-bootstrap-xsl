<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:param name="description">Nmap <xsl:value-of select="/nmaprun/@version"/> scan initiated <xsl:value-of select="/nmaprun/@startstr"/> as: <xsl:value-of select="/nmaprun/@args"/> </xsl:param>
    <xsl:param name="progress-width-up"><xsl:value-of select="/nmaprun/runstats/hosts/@up div /nmaprun/runstats/hosts/@total * 100"/></xsl:param>
    <xsl:param name="progress-width-down"><xsl:value-of select="/nmaprun/runstats/hosts/@down div /nmaprun/runstats/hosts/@total * 100"/></xsl:param>
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <html lang="en">
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>

          <title>Scan Report | Nmap <xsl:value-of select="/nmaprun/@version"/> | <xsl:value-of select="/nmaprun/@startstr"/></title>

          <meta name="referrer" content="no-referrer"/>
          <meta name="description" content="{$description}"/>

          <link rel="icon" href="https://cdn-icons-png.flaticon.com/16/159/159604.png" type="image/png"/>

          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
          <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.12.0/css/all.css" crossorigin="anonymous"/>
        </head>

        <body data-spy="scroll" data-target="#navbar-report">
          
          <nav class="navbar navbar-dark navbar-expand-lg bg-dark">
            <div class="container">
              <a class="navbar-brand" href="#">
                <i class="far fa-eye mr-2"></i> Scan Results
              </a>

              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
              </button>

              <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                  <li class="nav-item">
                    <a class="nav-link" href="#hosts">Scanned Hosts</a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link" href="#online">Online Hosts</a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link" href="#services">Services</a>
                  </li>
                </ul>
              </div>
            </div>
          </nav>


          <div class="container">
            <div class="jumbotron mt-4">
              <h1>Scan Report</h1>
              <p class="lead">Nmap <xsl:value-of select="/nmaprun/@version"/> | <xsl:value-of select="/nmaprun/@startstr"/></p>
              <pre><code><kbd class="px-2"><xsl:value-of select="/nmaprun/@args"/></kbd></code></pre>
              <hr class="my-4"/>
              <p class="lead">
                <xsl:value-of select="/nmaprun/@startstr"/>
                – 
                <xsl:value-of select="/nmaprun/runstats/finished/@timestr"/>
                <br/>
                <xsl:value-of select="/nmaprun/runstats/hosts/@total"/>
                hosts scanned | 
                <xsl:value-of select="/nmaprun/runstats/hosts/@up"/>
                hosts up | 
                <xsl:value-of select="/nmaprun/runstats/hosts/@down"/>
                hosts down
              </p>
              <div class="progress">
                <div class="progress-bar bg-success" role="progressbar" style="width: {$progress-width-up}%" aria-valuenow="{$progress-width-up}" aria-valuemin="0" aria-valuemax="100"><xsl:value-of select="/nmaprun/runstats/hosts/@up"/> Hosts Up (<xsl:value-of select="$progress-width-up"/>%)</div>
                <div class="progress-bar bg-danger" role="progressbar" style="width: {$progress-width-down}%" aria-valuenow="{$progress-width-down}" aria-valuemin="0" aria-valuemax="100"><xsl:value-of select="/nmaprun/runstats/hosts/@down"/> Hosts Down (<xsl:value-of select="$progress-width-down"/>%)</div>
              </div>
            </div>

            <h2 class="mb-4 mt-5" id="hosts">
              Scanned Hosts
              <xsl:if test="/nmaprun/runstats/hosts/@down > 1024"><small> (offline hosts are hidden)</small></xsl:if>
            </h2>

            <table class="table border">
              <thead class="thead-light">
                <tr>
                  <th scope="col" width="10%">State</th>
                  <th scope="col" width="30%">IP Address</th>
                  <th scope="col" width="30%">Hostname</th>
                  <th scope="col" width="15%">TCP (open)</th>
                  <th scope="col" width="15%">UDP (open)</th>
                </tr>
              </thead>
              <tbody>
                <xsl:choose>
                  <xsl:when test="/nmaprun/runstats/hosts/@down > 1024">
                    <xsl:for-each select="/nmaprun/host[status/@state='up']">
                      <tr>
                        <td>
                          <span class="badge badge-danger py-2 px-4 text-uppercase">
                            <xsl:if test="status/@state='up'">
                              <xsl:attribute name="class">badge badge-success py-2 px-4 text-uppercase</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="status/@state"/>
                          </span>
                        </td>
                        <td>
                          <xsl:value-of select="address/@addr"/>
                        </td>
                        <td>
                          <xsl:value-of select="hostnames/hostname/@name"/>
                        </td>
                        <td>
                          <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='tcp'])"/>
                        </td>
                        <td>
                          <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='udp'])"/>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="/nmaprun/host">
                      <tr>
                        <td>
                          <span class="badge badge-danger py-2 px-4 text-uppercase">
                            <xsl:if test="status/@state='up'">
                              <xsl:attribute name="class">badge badge-success py-2 px-4 text-uppercase</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="status/@state"/>
                          </span>
                        </td>
                        <td>
                          <xsl:value-of select="address/@addr"/>
                        </td>
                        <td>
                          <xsl:value-of select="hostnames/hostname/@name"/>
                        </td>
                        <td>
                          <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='tcp'])"/>
                        </td>
                        <td>
                          <xsl:value-of select="count(ports/port[state/@state='open' and @protocol='udp'])"/>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </tbody>
            </table>

            <h2 class="mb-4 mt-5" id="online">Online Hosts</h2>

            <xsl:for-each select="/nmaprun/host[status/@state='up']">
              <div class="card border-bottom-0 rounded-0">
                <div class="card-body">
                  <h4 class="mb-4">
                    <strong><xsl:value-of select="address/@addr"/></strong>
                    <xsl:if test="count(hostnames/hostname) > 0"> | <xsl:value-of select="hostnames/hostname/@name"/></xsl:if>
                  </h4>

                  <div class="row">
                    <div class="col-md-4">
                      <h6 class="font-weight-bold">IP Addresses</h6>
                      <xsl:if test="count(address) = 0">
                        Unable to identify IP Addresses.
                      </xsl:if>

                      <ul>
                        <xsl:for-each select="address">
                          <li>
                            <xsl:value-of select="@addr"/>
                            <xsl:if test="@vendor != ''">
                              <xsl:text> - </xsl:text>
                              <xsl:value-of select="@vendor"/>
                            </xsl:if>
                            <span class="badge badge-secondary text-uppercase ml-2">
                              <xsl:value-of select="@addrtype"/>
                            </span>
                          </li>
                        </xsl:for-each>
                      </ul>

                      <h6 class="font-weight-bold">Hostnames</h6>
                      <xsl:if test="count(hostnames/hostname) = 0">
                        Unable to identify hostnames.
                      </xsl:if>

                      <ul>
                        <xsl:for-each select="hostnames/hostname">
                          <li>
                            <xsl:value-of select="@name"/>
                            <span class="badge badge-secondary text-uppercase ml-2">
                              <xsl:value-of select="@type"/>
                            </span>
                          </li>
                        </xsl:for-each>
                      </ul>
                    </div>

                    <div class="col-md-4">
                      <h6 class="font-weight-bold">Remote Operating System Detection</h6>
                      <xsl:if test="count(os/osmatch) = 0">
                        <p>Unable to identify the remote operating system.</p>
                      </xsl:if>

                      <ul>
                        <xsl:for-each select="os/portused">
                          <li>
                            Used port: 
                            <xsl:value-of select="@portid" />
                            /
                            <xsl:value-of select="@proto" />
                            <span class="badge badge-secondary ml-1">
                              <xsl:value-of select="@state" />
                            </span>
                          </li>
                        </xsl:for-each>
                        <xsl:for-each select="os/osmatch">
                          <li>
                            OS match: 
                            <xsl:value-of select="@name" />
                            <span class="badge badge-info ml-1">
                              <xsl:value-of select="@accuracy" />
                              %
                            </span>
                          </li>
                        </xsl:for-each>
                      </ul>

                      <h6 class="font-weight-bold">Host Script</h6>
                      <xsl:if test="count(hostscript/script) = 0">
                        <p>Host script was not run.</p>
                      </xsl:if>

                      <xsl:for-each select="hostscript/script">
                        <h6>
                          <xsl:value-of select="@id"/>
                        </h6>
                        <pre><code><xsl:value-of select="@output"/></code></pre>
                      </xsl:for-each>
                    </div>
                  </div>
                </div>
              </div>

              <xsl:if test="count(ports/port) > 0">
                <table class="table border">
                  <thead>
                    <tr>
                      <th>Port</th>
                      <th>Protocol</th>
                      <th>State</th>
                      <th>Service</th>
                      <th>Reason</th>
                      <th>Product</th>
                      <th>Version</th>
                      <th>Extra Info</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="ports/port">
                      <xsl:choose>
                        <xsl:when test="state/@state = 'open'">
                          <tr class="table-success">
                            <td title="Port">
                              <xsl:value-of select="@portid"/>
                            </td>
                            <td title="Protocol">
                              <xsl:value-of select="@protocol"/>
                            </td>
                            <td title="State">
                              <xsl:value-of select="state/@state"/>
                            </td>
                            <td title="Service">
                              <xsl:value-of select="service/@name"/>
                            </td>
                            <td title="Reason">
                              <xsl:value-of select="state/@reason"/>
                            </td>
                            <td title="Product">
                              <xsl:value-of select="service/@product"/>
                            </td>
                            <td title="Version">
                              <xsl:value-of select="service/@version"/>
                            </td>
                            <td title="Extra Info">
                              <xsl:value-of select="service/@extrainfo"/>
                            </td>
                          </tr>
                        </xsl:when>
                        <xsl:when test="state/@state = 'filtered'">
                          <tr class="table-warning">
                            <td title="Port">
                              <xsl:value-of select="@portid"/>
                            </td>
                            <td title="Protocol">
                              <xsl:value-of select="@protocol"/>
                            </td>
                            <td title="State">
                              <xsl:value-of select="state/@state"/>
                            </td>
                            <td title="Service">
                              <xsl:value-of select="service/@name"/>
                            </td>
                            <td title="Reason">
                              <xsl:value-of select="state/@reason"/>
                            </td>
                            <td title="Product">
                              <xsl:value-of select="service/@product"/>
                            </td>
                            <td title="Version">
                              <xsl:value-of select="service/@version"/>
                            </td>
                            <td title="Extra Info">
                              <xsl:value-of select="service/@extrainfo"/>
                            </td>
                          </tr>
                        </xsl:when>
                        <xsl:when test="state/@state = 'closed'">
                          <tr class="table-secondary">
                            <td title="Port">
                              <xsl:value-of select="@portid"/>
                            </td>
                            <td title="Protocol">
                              <xsl:value-of select="@protocol"/>
                            </td>
                            <td title="State">
                              <xsl:value-of select="state/@state"/>
                            </td>
                            <td title="Service">
                              <xsl:value-of select="service/@name"/>
                            </td>
                            <td title="Reason">
                              <xsl:value-of select="state/@reason"/>
                            </td>
                            <td title="Product">
                              <xsl:value-of select="service/@product"/>
                            </td>
                            <td title="Version">
                              <xsl:value-of select="service/@version"/>
                            </td>
                            <td title="Extra Info">
                              <xsl:value-of select="service/@extrainfo"/>
                            </td>
                          </tr>
                        </xsl:when>
                        <xsl:otherwise>
                          <tr class="table-info">
                            <td title="Port">
                              <xsl:value-of select="@portid"/>
                            </td>
                            <td title="Protocol">
                              <xsl:value-of select="@protocol"/>
                            </td>
                            <td title="State">
                              <xsl:value-of select="state/@state"/>
                            </td>
                            <td title="Service">
                              <xsl:value-of select="service/@name"/>
                            </td>
                            <td title="Reason">
                              <xsl:value-of select="state/@reason"/>
                            </td>
                            <td title="Product">
                              <xsl:value-of select="service/@product"/>
                            </td>
                            <td title="Version">
                              <xsl:value-of select="service/@version"/>
                            </td>
                            <td title="Extra Info">
                              <xsl:value-of select="service/@extrainfo"/>
                            </td>
                          </tr>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </tbody>
                </table>
              </xsl:if>
            </xsl:for-each>

            <h2 class="mb-4 mt-5" id="services">Open Services</h2>
            <table class="table border mb-5">
              <thead class="thead-light">
                <tr>
                  <th>Address</th>
                  <th>Port</th>
                  <th>Protocol</th>
                  <th>Service</th>
                  <th>Product</th>
                  <th>Version</th>
                  <th>CPE</th>
                  <th>Extra info</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="/nmaprun/host">
                  <xsl:for-each select="ports/port[state/@state='open']">
                    <tr>
                      <td>
                        <xsl:value-of select="../../address/@addr"/>
                        <xsl:if test="count(../../hostnames/hostname) > 0">
                          - 
                          <xsl:value-of select="../../hostnames/hostname/@name"/>
                        </xsl:if>
                      </td>
                      <td>
                        <xsl:value-of select="@portid"/>
                      </td>
                      <td>
                        <xsl:value-of select="@protocol"/>
                      </td>
                      <td>
                        <xsl:value-of select="service/@name"/>
                      </td>
                      <td>
                        <xsl:value-of select="service/@product"/>
                      </td>
                      <td>
                        <xsl:value-of select="service/@version"/>
                      </td>
                      <td>
                        <xsl:value-of select="service/cpe"/>
                      </td>
                      <td>
                        <xsl:value-of select="service/@extrainfo"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
            </table>

          </div>

          <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
          <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        </body>
      </html>
  </xsl:template>
</xsl:stylesheet>