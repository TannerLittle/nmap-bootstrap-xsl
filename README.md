# nmap-bootstrap-xsl

Bootstrap 4 nmap scan report stylesheet, view the formatted results of an nmap scan in a browser.

Originally based off of https://github.com/honze-net/nmap-bootstrap-xsl

## Usage

### Add Stylesheet to XML

#### New Scan

1. Export the scan as XML using the `-oX <filename>` flag (or `-oA <name>`).
2. Set `nmap.xsl` as the stylesheet using the `--stylesheet <filename>` flag.

![https://i.imgur.com/LE2Jbbi.png](https://i.imgur.com/LE2Jbbi.png) 

#### Existing Scan (with XML output)

1. Insert the following snippet after `<!DOCTYPE nmaprun>` in the XML output.

   ``` <?xml-stylesheet href="nmap.xsl" type="text/xsl"?> ```

## Export to HTML

Export the styled XML output to HTML for viewing in-browser or sharing.

``` xsltproc scanme.xml -o scanme.html ```

## Screenshots

![https://i.imgur.com/8wln8e7.png](https://i.imgur.com/8wln8e7.png)

![https://i.imgur.com/nATFBMO.png](https://i.imgur.com/nATFBMO.png)

![https://i.imgur.com/V2EF0Cy.png](https://i.imgur.com/V2EF0Cy.png)