{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python, openssl }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "0yp8vmj3yc564hcmhx46ssyn8qayywnsrg4wg67qk6jw967qgwsn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib perl python openssl ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = https://github.com/edenhill/librdkafka;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ boothead wkennington ];
  };
}
