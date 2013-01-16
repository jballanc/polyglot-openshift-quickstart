# Required TorqueBox environment variables
export TORQUEBOX_HOME=$OPENSHIFT_DATA_DIR/polyglot
export JRUBY_HOME=$TORQUEBOX_HOME/jruby
export PATH=$JRUBY_HOME/bin:$PATH

function download_torquebox() {
    # Determine whether we're getting a release or an incremental 
    if [[ ${TORQUEBOX_VERSION} =~ \. ]]; then
        # Official release, e.g. 0.9.0
        URL=http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/${TORQUEBOX_VERSION}/torquebox-dist-${TORQUEBOX_VERSION}-bin.zip
    else
        # Incremental build, e.g. 999 or LATEST
        URL=http://repository-projectodd.forge.cloudbees.com/incremental/torquebox/${TORQUEBOX_VERSION}/torquebox-dist-bin.zip
    fi

    pushd ${OPENSHIFT_DATA_DIR} > /dev/null
    if [[ ${FORCE_BUILD} == true ]]; then
        rm -f torquebox
    fi
    # Download/explode the dist and symlink it to torquebox
    if [ ! -d torquebox ]; then
        rm -rf torquebox*
        wget -nv ${URL}
        unzip -q torquebox-dist-*.zip
        rm torquebox-dist-*.zip
        ln -s torquebox-* torquebox
        echo "Downloaded" torquebox-*
    fi
    popd > /dev/null
}


function bundle_install() {
    find ${OPENSHIFT_REPO_DIR}/apps -t d -maxdepth 1 -print0 | while read -d $'\0' dir
    do
        if [ ! -d "${dir}/.bundle" ] && [ -f "${dir}/Gemfile" ]; then
          pushd ${dir} > /dev/null
          jruby -J-Xmx256m -J-Dhttps.protocols=SSLv3 -S bundle install --without development
          popd > /dev/null
        fi
    done
}

function db_migrate() {
    find ${OPENSHIFT_REPO_DIR}/apps -t d -maxdepth 1 -print0 | while read -d $'\0' dir
    do
        pushd ${dir} > /dev/null
            bundle exec rake db:migrate RAILS_ENV="production"
        popd > /dev/null
    done
}
