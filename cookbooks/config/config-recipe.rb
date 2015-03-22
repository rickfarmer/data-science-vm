name "config-recipe"

default_attributes(
    "java" => {
        "install_flavor" => "oracle",
        "jdk_version" => 7,
        "oracle" => {
                "accept_oracle_download_terms" => true
        }
    }
)

run_list(
    "recipe[yum]",
    "recipe[vim]",
    "recipe[build-essential]",
    "recipe[java]"
)