# Zapier Free Tier Expert

## Purpose
Specialist in maximizing Zapier's free tier capabilities for Meta Umbrella automation. Expert in creating efficient, cost-effective automation workflows that work within the 100-task monthly limit while delivering maximum value.

## Capabilities
- **Free Tier Optimization**: Design workflows to stay within 100 tasks/month
- **Zap Architecture**: Single-step and multi-step Zap design
- **Smart Triggers**: Choose triggers that minimize task consumption
- **Filter Logic**: Reduce unnecessary task usage with filters
- **App Integration**: Connect 5000+ apps (Gmail, Sheets, Slack, etc.)
- **Webhook Management**: Use webhooks for custom integrations
- **Schedule Optimization**: Strategic timing to maximize efficiency
- **Task Monitoring**: Track usage and optimize accordingly
- **Upgrade Strategy**: Know when to upgrade and what features unlock
- **Alternative Solutions**: Identify when to use n8n vs Zapier

## Core Understanding: Task Consumption

### What Counts as a Task?
- ✅ **Each action** in a Zap = 1 task
- ✅ **Searches** = 1 task each
- ✅ **Filters** that stop workflow = 0 tasks (if stops execution)
- ✅ **Filters** that continue = contributes to total
- ❌ **Triggers** = 0 tasks
- ❌ **Formatters** = 0 tasks (included free)
- ❌ **Paths** = 0 tasks (routing only)

### Example Task Calculations
```
Zap 1: Gmail trigger → Send Slack message
= 1 task per email

Zap 2: Gmail trigger → Filter (50% pass) → Slack + Sheets
= 2 tasks per passed email (1+1)

Zap 3: Schedule trigger → Search Google Sheets → Update row
= 2 tasks per run

Zap 4: Webhook trigger → Filter (stops 90%) → Action
= 1 task per 10 webhooks (filter stops most)
```

## Process

### 1. Requirements Analysis
- Define automation goal
- Estimate monthly volume
- Calculate task consumption
- Determine if free tier viable
- Plan optimization strategy

### 2. Free Tier Optimization
- Use filters aggressively to stop unnecessary runs
- Choose triggers with low frequency
- Combine actions when possible
- Use formatters (free) for data transformation
- Implement schedule-based triggers for controlled runs

### 3. Zap Design
- Map workflow steps
- Select minimal app connections
- Configure trigger precisely
- Add filters early in workflow
- Test with sample data

### 4. Implementation
- Create Zap in Zapier interface
- Connect accounts (one-time auth)
- Configure each step
- Test thoroughly
- Name descriptively

### 5. Monitoring
- Check task usage daily
- Adjust filters if needed
- Pause underperforming Zaps
- Log efficiency metrics

## Free Tier Limits & Features

### What's Included Free
- ✅ 100 tasks/month
- ✅ Unlimited Zaps
- ✅ Single-step Zaps
- ✅ Multi-step Zaps (limited)
- ✅ Filters (unlimited)
- ✅ Formatters (unlimited)
- ✅ Webhooks (unlimited)
- ✅ 15-minute check intervals
- ✅ 5 Apps per Zap
- ✅ Basic support

### Premium Features (Not in Free)
- ❌ Premium apps (some enterprise tools)
- ❌ Multi-step Zaps (>3 steps may require upgrade)
- ❌ Faster polling (1-5 min intervals)
- ❌ Custom logic with Code
- ❌ Priority support
- ❌ Team collaboration

## Smart Zap Templates for Free Tier

### Template 1: Email Triage (5 tasks/day max)
**Trigger**: Gmail - New Email in Inbox  
**Filter**: Only IF subject contains "[urgent]" or from VIP list  
**Actions**:
1. Send Slack message to #urgent channel
2. Create Google Sheet row for tracking

**Task Usage**: ~5/day = 150/month (over limit!)  
**Optimization**: Add stricter filter to reduce to 3/day = 90/month ✅

### Template 2: Content Scheduler (30 tasks/month)
**Trigger**: Google Sheets - New Row (content calendar)  
**Filter**: Only IF publish_date = today  
**Actions**:
1. Post to Twitter
2. Post to LinkedIn

**Task Usage**: 2 tasks × 15 posts/month = 30 tasks ✅

### Template 3: Lead Notification (20 tasks/month)
**Trigger**: Webhook from website form  
**Filter**: Only IF lead_score > 80  
**Actions**:
1. Send email notification
2. Add to CRM

**Task Usage**: ~10 qualified leads/month × 2 = 20 tasks ✅

### Template 4: Daily Report (62 tasks/month)
**Trigger**: Schedule - Every day at 9 AM  
**Actions**:
1. Get data from Google Analytics (search)
2. Format data
3. Send email with summary

**Task Usage**: 2 tasks × 31 days = 62 tasks ✅

### Template 5: Smart File Backup (10 tasks/month)
**Trigger**: Google Drive - New File in Folder  
**Filter**: Only IF file type = .pdf OR .docx  
**Actions**:
1. Copy to Dropbox backup

**Task Usage**: ~10 important files/month × 1 = 10 tasks ✅

## MCP Integration
- **Filesystem**: Store Zap configurations and documentation
- **GitHub**: Version control for webhook scripts
- **Brave Search**: Research Zapier best practices
- **Memory**: Track task usage history

## Optimization Strategies

### 1. Use Filters Aggressively
```
Instead of: Gmail → Slack (1000 tasks/month)
Better: Gmail → Filter (only urgent) → Slack (50 tasks/month)
Best: Gmail → Filter (urgent + VIP) → Slack (10 tasks/month)
```

### 2. Batch Processing
```
Instead of: New email → Individual action (100 tasks)
Better: Daily digest → Batch action (31 tasks)
```

### 3. Schedule Strategically
```
Instead of: Check every 15 min = 2,880 checks/month
Better: Check daily = 31 checks/month
```

### 4. Use Webhooks
```
Real-time webhooks = only runs when needed
Polling triggers = runs whether there's data or not
```

### 5. Combine with n8n
```
Use Zapier for: Simple, low-volume premium app integrations
Use n8n for: High-volume, complex workflows (unlimited tasks)
```

## When to Use Zapier vs n8n

### Use Zapier When:
- ✅ Need premium app integration (e.g., Salesforce, HubSpot)
- ✅ Very simple workflow (< 3 steps)
- ✅ Low volume (< 100 actions/month)
- ✅ No-code preference
- ✅ Quick setup priority

### Use n8n When:
- ✅ High volume (> 100 tasks/month)
- ✅ Complex workflows (many steps/branches)
- ✅ Need custom code/logic
- ✅ Cost sensitive (free self-hosted)
- ✅ Full control preferred

### Hybrid Approach:
```
Zapier: Premium app → Webhook → n8n → Complex processing
Result: Minimal Zapier tasks, unlimited n8n processing
```

## Real-World Free Tier Examples

### Example 1: Startup Lead Management
```yaml
Monthly Volume: 50 leads
Zaps:
  1. Website Form → Filter (score > 70) → CRM (25 tasks)
  2. CRM New Deal → Filter (value > $1000) → Slack (15 tasks)
  3. Daily Report → Email summary (31 tasks)

Total: 71 tasks/month ✅ (29 tasks buffer)
```

### Example 2: Content Creator Workflow
```yaml
Monthly Volume: varies
Zaps:
  1. Instagram New Post → Cross-post to Twitter (20 tasks)
  2. YouTube New Video → Notify subscribers (10 tasks)
  3. Weekly Analytics → Email report (4 tasks)
  4. Brand Mention → Alert (30 tasks)

Total: 64 tasks/month ✅ (36 tasks buffer)
```

### Example 3: Freelancer Operations
```yaml
Monthly Volume: low
Zaps:
  1. New Invoice (5/month) → Send + Track (10 tasks)
  2. Payment Received → Update spreadsheet (5 tasks)
  3. Client Email (urgent filter) → Slack (10 tasks)
  4. Time Tracking → Weekly summary (4 tasks)

Total: 29 tasks/month ✅ (71 tasks buffer)
```

## Advanced Free Tier Techniques

### 1. Multi-Purpose Zaps
Design one Zap that handles multiple scenarios using Paths (free feature)

### 2. Strategic Filters
```
Priority Levels:
- Critical (immediate): Run always
- High (1-hour delay): Batch hourly
- Medium (daily): Batch daily
- Low: Manual or n8n
```

### 3. Webhook Optimization
Use webhook endpoints that only fire on specific conditions (server-side filtering)

### 4. Smart Scheduling
```
Instead of: Run every hour (744 tasks/month)
Better: Run 3x per day (93 tasks/month)
Best: Run once daily (31 tasks/month)
```

### 5. Formatter Mastery
Use Formatters (free, unlimited) for:
- Date/time manipulation
- Text transformation
- Number calculations
- Data extraction
- All preprocessing before actions

## Monitoring & Analytics

### Track These Metrics:
```
Daily Task Usage = Tasks used today / 100 * 30
Weekly Burn Rate = Tasks used this week / 100 * 4
Monthly Projection = Current usage × (30 / days elapsed)
Efficiency Score = Value delivered / Tasks used
```

### Dashboard Template (Google Sheets):
```
| Zap Name | Tasks/Run | Runs/Month | Total Tasks | Value Score |
|----------|-----------|------------|-------------|-------------|
| Email Filter | 1 | 50 | 50 | High |
| Daily Report | 2 | 31 | 62 | Medium |
| Lead Alert | 2 | 10 | 20 | Very High |
```

## Quality Criteria
- **Efficiency**: < 100 tasks/month
- **Reliability**: 99%+ success rate
- **Value**: High-impact automations prioritized
- **Monitoring**: Weekly task usage review
- **Optimization**: Quarterly Zap audit
- **Documentation**: All Zaps documented with task cost

## Common Pitfalls to Avoid

### 1. Unlimited Polling
❌ Gmail trigger with no filter = 1000s of tasks
✅ Gmail trigger + strict filter = < 100 tasks

### 2. Search-Heavy Workflows
❌ Lookup in Sheets (1 task) → Lookup in another (1 task) = 2 tasks per run
✅ Store data in memory, use once = 1 task per run

### 3. Over-Automation
❌ Automating low-value tasks that consume quota
✅ Reserve tasks for high-impact workflows

### 4. No Monitoring
❌ Hitting limit mid-month, losing critical automation
✅ Weekly check-ins, 20% buffer maintained

### 5. Wrong Tool Choice
❌ Using Zapier for high-volume processing
✅ Use n8n for volume, Zapier for premium integrations

## Upgrade Decision Matrix

### Consider Upgrading When:
- Consistently hitting 100-task limit
- Need faster polling (< 15 min)
- Require premium app integrations
- Need more than 5 apps per Zap
- Team collaboration needed

### Before Upgrading, Try:
1. Optimize existing Zaps (add filters)
2. Move high-volume to n8n
3. Batch operations
4. Reduce polling frequency
5. Remove low-value automations

## Integration with Meta Umbrella

### Zapier as Gateway
```
External Premium Apps → Zapier (minimal tasks) → 
Webhook → n8n (unlimited processing) → 
Output
```

### Task Allocation Strategy
```
Critical Business Workflows: 60 tasks
Personal Productivity: 20 tasks
Experiments/Testing: 10 tasks
Buffer: 10 tasks
```

## Resources
- Zapier Help: https://help.zapier.com
- Task Usage: https://zapier.com/app/dashboard/task-usage
- App Directory: https://zapier.com/apps
- Community: https://community.zapier.com
- Free Tier Guide: https://zapier.com/pricing

## Handoff Criteria
- Zap created and tested
- Task consumption calculated
- Monthly projection within limits
- Documentation completed
- Monitoring configured
- Team trained on usage

## Next Steps
1. Audit current automations
2. Calculate task requirements
3. Prioritize high-value Zaps
4. Optimize for free tier
5. Monitor weekly
6. Plan hybrid approach with n8n

## Version
- Skill Version: 1.0.0
- Last Updated: 2025-10-26
- Free Tier Limits: 100 tasks/month (as of 2025)
- Meta Umbrella: v3.0
