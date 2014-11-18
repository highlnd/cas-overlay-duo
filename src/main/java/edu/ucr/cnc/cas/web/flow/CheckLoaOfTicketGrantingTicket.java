package edu.ucr.cnc.cas.web.flow;

import edu.ucr.cnc.cas.support.CasConstants;
import org.apache.log4j.Logger;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.Service;
import org.jasig.cas.services.RegisteredService;
import org.jasig.cas.services.ServicesManager;
import org.jasig.cas.ticket.TicketGrantingTicket;
import org.jasig.cas.ticket.TicketGrantingTicketImpl;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.springframework.webflow.action.AbstractAction;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;

import javax.validation.constraints.NotNull;

/**
 * CheckLoadOfTicketGrantingTicket is a Spring MVC {@link AbstractAction} that looks at the requirements of
 * the service the user is attempting to login to, as well as the users requirements to use MFA or not and either:
 *
 * 1. Requires a reauthentication using two factors if the original TGT was acquired using a single factor and the
 * service requires two factors.
 * 2. Determines that the LOA of the TGT is sufficient and continues the login webflow.
 *
 * @author Michael Kennedy <michael.kennedy@ucr.edu>
 * @version 1.0
 */
public class CheckLoaOfTicketGrantingTicket extends AbstractAction {

    private Logger logger = Logger.getLogger(this.getClass());

    @NotNull
    private ServiceSecondFactorLookupManager serviceSecondFactorLookupManager;

    @NotNull
    private ServicesManager servicesManager;

    @NotNull
    private TicketRegistry ticketRegistry;

    @NotNull
    private UserSecondFactorLookupManager userSecondFactorLookupManager;

    @Override
    protected Event doExecute(RequestContext context) throws Exception {

        if(logger.isDebugEnabled()) {
            logger.debug("Checking the LOA of a TGT");
        }

        // Get the TGT id from the flow scope and retrieve the actual TGT from the ticket registry
        String ticketGrantingTicketId = (String)context.getFlowScope().get("ticketGrantingTicketId");
        TicketGrantingTicketImpl ticketGrantingTicket;
        ticketGrantingTicket = (TicketGrantingTicketImpl)this.ticketRegistry.getTicket(ticketGrantingTicketId, TicketGrantingTicket.class);

        logger.debug("TGT is " + ticketGrantingTicketId);

        // If there isn't a matching TGT in the registry let the user continue
        if (ticketGrantingTicket == null) {
            this.logger.debug("no TGT found for TGT ID '" + ticketGrantingTicketId + "'");
            return result("continue");
        }

        String serviceAuthMechanism = null;

        // Get the registered service from flow scope
        Service service = (Service)context.getFlowScope().get("service");
        RegisteredService registeredService = this.servicesManager.findServiceBy(service);
        serviceAuthMechanism = this.serviceSecondFactorLookupManager.getMFARequiredValue(registeredService);

        if (registeredService != null) {
            this.logger.debug("serviceId of service is " + registeredService.getServiceId());
        }
        else {
            this.logger.debug("the service value is null");
        }

        // Get the LOA of the current TGT
        String tgtLOA = (String)ticketGrantingTicket.getAuthentication().getAttributes().get(CasConstants.LOA_ATTRIBUTE);

        logger.debug("LOA of TGT " + ticketGrantingTicketId + " is set to " + tgtLOA);

        if((serviceAuthMechanism == null) || (serviceAuthMechanism.equals("NO") || tgtLOA.equals(CasConstants.LOA_TF))) {
            this.logger.debug("returning continue");
            return result("continue");
        }

        if(serviceAuthMechanism.equals("YES") && tgtLOA.equals(CasConstants.LOA_SF)) {
            this.logger.debug("returning renewForTwoFactor");
            return result("renewForTwoFactor");
        }

        Principal principal = ticketGrantingTicket.getAuthentication().getPrincipal();
        String userMFARequiredValue = this.userSecondFactorLookupManager.getMFARequiredValue(principal);

        if (userMFARequiredValue != null && userMFARequiredValue.equals("YES")) {
            this.logger.debug("returning renewForTwoFactor");
            return result("renewForTwoFactor");
        }

        this.logger.debug("catch-all: returning continue");
        return result("continue");
    }

    public ServiceSecondFactorLookupManager getServiceSecondFactorLookupManager() {
        return serviceSecondFactorLookupManager;
    }

    /**
     * Sets the object that should lookup the second factor mechanism used
     *
     * @param serviceSecondFactorLookupManager a ServiceSecondFactorLookupManager object
     */
    public void setServiceSecondFactorLookupManager(ServiceSecondFactorLookupManager serviceSecondFactorLookupManager) {
        this.serviceSecondFactorLookupManager = serviceSecondFactorLookupManager;
    }

    public ServicesManager getServicesManager() {
        return servicesManager;
    }

    public void setServicesManager(ServicesManager servicesManager) {
        this.servicesManager = servicesManager;
    }

    public TicketRegistry getTicketRegistry() {
        return ticketRegistry;
    }

    public void setTicketRegistry(TicketRegistry ticketRegistry) {
        this.ticketRegistry = ticketRegistry;
    }

    public UserSecondFactorLookupManager getUserSecondFactorLookupManager() {
        return userSecondFactorLookupManager;
    }

    public void setUserSecondFactorLookupManager(UserSecondFactorLookupManager userSecondFactorLookupManager) {
        this.userSecondFactorLookupManager = userSecondFactorLookupManager;
    }
}
