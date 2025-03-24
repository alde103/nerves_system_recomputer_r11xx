#############################################################
#
# recomputer-r110x
#
#############################################################

# Remember to bump the version when anything changes in this
# directory.
RECOMPUTER_R110X_SOURCE =
RECOMPUTER_R110X_VERSION = 0.0.1
RECOMPUTER_R110X_DEPENDENCIES += host-dtc

define RECOMPUTER_R110X_BUILD_CMDS
	cp $(NERVES_DEFCONFIG_DIR)/package/recomputer-r110x/*.dts* $(@D)
        for filename in $(@D)/*.dts; do \
            $(CPP) -I$(@D) -I $(LINUX_SRCDIR)include -I $(LINUX_SRCDIR)arch -nostdinc -undef -D__DTS__ -x assembler-with-cpp $$filename | \
              $(HOST_DIR)/usr/bin/dtc -Wno-unit_address_vs_reg -@ -I dts -O dtb -b 0 -o $${filename%.dts}.dtbo || exit 1; \
        done
endef

define RECOMPUTER_R110X_INSTALL_TARGET_CMDS
	echo "$(@D)/*.dtbo -> $(BINARIES_DIR)/rpi-firmware/overlays/"
	$(INSTALL) -D -m 0644 $(@D)/*.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/

endef

$(eval $(generic-package))
