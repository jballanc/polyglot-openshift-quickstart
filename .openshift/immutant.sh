function download_immutant() {
    # Determine whether we're getting a release or an incremental 
    if [[ ${IMMUTANT_VERSION} =~ \. ]]; then
        # Official release, e.g. 0.9.0
        URL=http://repository-projectodd.forge.cloudbees.com/release/org/immutant/immutant-dist/${IMMUTANT_VERSION}/immutant-dist-${IMMUTANT_VERSION}-bin.zip
    else
        # Incremental build, e.g. 999 or LATEST
        URL=http://repository-projectodd.forge.cloudbees.com/incremental/immutant/${IMMUTANT_VERSION}/immutant-dist-bin.zip
    fi

    pushd ${OPENSHIFT_DATA_DIR} >/dev/null
    if [[ ${FORCE_BUILD} == true ]]; then
        rm -f immutant
    fi
    # Download/explode the dist and symlink it to immutant
    if [ ! -d immutant ]; then
        rm -rf immutant*
        wget -nv ${URL}
        unzip -q immutant-dist-*.zip
        rm immutant-dist-*.zip
        ln -s immutant-* immutant
        echo "Downloaded" immutant-*
    fi
    popd >/dev/null
}
