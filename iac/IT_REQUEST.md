# IT Request: OpenWebUI Horizontal Scaling Migration

## 📋 **Request Summary**
**Simple DNS endpoint change for OpenWebUI horizontal scaling implementation**

---

## 🎯 **Required Change**
**Update Microsoft Entra App Proxy backend configuration:**

| Field | Current Value | New Value |
|-------|---------------|-----------|
| Backend URL | `http://ai.ggai:8080` | `http://ai-scaled.ggai:8080` |

---

## ⏱️ **Impact & Timing**
- **Downtime**: < 30 seconds (DNS propagation)
- **Risk Level**: **Very Low** (simple DNS change)
- **Rollback Time**: < 30 seconds (revert DNS change)
- **User Impact**: Minimal (brief reconnection required)

---

## ✅ **Pre-Migration Validation**
**All testing completed successfully:**

```bash
# DNS Resolution Test ✅
nslookup ai-scaled.ggai
# Result: Points to load balancer (192.168.144.126, 192.168.144.75)

# HTTP Health Check Test ✅  
curl -I http://ai-scaled.ggai:8080/health
# Result: HTTP 200 OK

# Load Balancing Test ✅
# Result: Traffic distributed across multiple healthy instances
```

---

## 🎯 **Business Justification**

### **💰 Cost Impact: 40% SAVINGS ($1,644/year)**
- **Current Cost:** $340.22/month (over-provisioned single instance)
- **New Cost:** $203.15/month (right-sized horizontal scaling)
- **Monthly Savings:** $137.07/month = **$1,644.84 annual savings**

### **Current Limitations (Single Instance):**
- ❌ No redundancy - single point of failure
- ❌ No load distribution - performance bottlenecks
- ❌ No auto-scaling - cannot handle traffic spikes
- ❌ Manual intervention required for outages
- ❌ Over-provisioned resources (8 vCPU, 32 GB unused capacity)

### **New Benefits (Horizontal Scaling):**
- ✅ **High Availability**: 2-10 instances with automatic failover
- ✅ **Auto-Scaling**: Automatic scaling based on CPU utilization
- ✅ **Load Distribution**: Traffic balanced across healthy instances
- ✅ **Session Management**: Redis-based session sharing
- ✅ **Health Monitoring**: Automatic unhealthy instance removal
- ✅ **Resource Optimization**: Right-sized instances (50% CPU/Memory reduction)

---

## 🛡️ **Risk Mitigation**

### **Rollback Plan**
**If any issues occur, immediately revert:**
```
Backend URL: http://ai-scaled.ggai:8080 → http://ai.ggai:8080
Rollback Time: < 30 seconds
```

### **Monitoring During Migration**
- **Health Dashboard**: WebUI-HorizontalScaling (CloudWatch)
- **Instance Count**: 2 healthy instances minimum
- **Response Time**: < 2 seconds average
- **Error Rate**: < 0.1%

---

## 📞 **Technical Contacts**
- **Primary**: [Your Name] - [Your Email]
- **Infrastructure Team**: Available for support during migration
- **Escalation**: [Manager Name] - [Manager Email]

---

## 📅 **Proposed Timeline**
1. **Pre-Change**: Validate all endpoints (COMPLETED)
2. **Change Window**: [Specify preferred maintenance window]
3. **Post-Change**: Monitor for 30 minutes
4. **Sign-off**: Confirm successful migration

---

## 🔍 **Technical Details**
### **Current Architecture:**
```
Entra App Proxy → ai.ggai:8080 → Single OpenWebUI Instance
```

### **New Architecture:**
```
Entra App Proxy → ai-scaled.ggai:8080 → Load Balancer → Multiple OpenWebUI Instances
                                                        ↓
                                                   Redis Session Sharing
```

### **Infrastructure Components:**
- **Load Balancer**: AWS Application Load Balancer (internal)
- **Compute**: 2-10 AWS Fargate instances (auto-scaling)
- **Session Store**: AWS ElastiCache Redis
- **Database**: Existing Aurora PostgreSQL (no changes)
- **Storage**: Existing EFS (no changes)

---

## ✅ **Approval & Sign-off**

**Requested by:** [Your Name]  
**Date:** [Current Date]  
**Priority:** Normal  

**IT Team Approval:**  
☐ Infrastructure Team Lead  
☐ Network Team Lead  
☐ Security Team (if required)  

**Execution Authorization:**  
☐ Change Management Approval  
☐ Business Owner Sign-off  

---

**Questions? Contact [Your Email] or [Your Phone]** 