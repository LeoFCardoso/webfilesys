This is a very simple webfilesys port to run with readonly users only.
PDFViewHandler is installed by default.

Remember to install the non-public libraries into your local maven repository (please look at original readme.txt in original project also).

mvn install:install-file -Dfile=[your-path-to-project-webfilesys]/maven-repository/com/drew/metadata-extractor/2.3.1/metadata-extractor-2.3.1.jar -DgroupId=com.drew -DartifactId=metadata-extractor -Dversion=2.3.1 -Dpackaging=jar

mvn install:install-file -Dfile=[your-path-to-project-webfilesys]/maven-repository/com/googlecode/compress-j2me/0.3/compress-j2me-0.3.jar -DgroupId=com.googlecode -DartifactId=compress-j2me -Dversion=0.3 -Dpackaging=jar

mvn install:install-file -Dfile=[your-path-to-project-webfilesys]/maven-repository/com/ice/tar/javatar/2.3/javatar-2.3.jar -DgroupId=com.ice.tar -DartifactId=javatar -Dversion=2.3 -Dpackaging=jar

mvn install:install-file -Dfile=[your-path-to-project-webfilesys]/maven-repository/com/keypoint/png-gif/1.0/png-gif-1.0.jar -DgroupId=com.keypoint -DartifactId=png-gif -Dversion=1.0 -Dpackaging=jar
