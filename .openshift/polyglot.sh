function overlay_jboss() {
    # Determine whether Immutant or TorqueBox is newer, and copy the newer one
    # over the older one
    pushd ${OPENSHIFT_DATA_DIR} >/dev/null
    mkdir -p polyglot
    if [ torquebox -nt immutant ]; then
        echo "TorqueBox is newer..."
        cp -R immutant/ polyglot/
        cp -R torquebox/ polyglot/
    else
        echo "Immutant is newer..."
        cp -R torquebox/ polyglot/
        cp -R immutant/ polyglot/
    fi
    echo "TorqueBox and Immutant overlayed!"
    popd >/dev/null
}
