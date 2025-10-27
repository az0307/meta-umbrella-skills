# Playwright & Puppeteer Automation Specialist

## Purpose
Master of browser automation using Playwright and Puppeteer for web scraping, testing, monitoring, and task automation.

## Capabilities
- Multi-browser automation (Chromium, Firefox, WebKit)
- Web scraping and data extraction
- E2E testing and visual regression
- Form automation and authentication
- Screenshot and PDF generation
- Network interception and mocking
- Performance monitoring and profiling
- Anti-detection and stealth mode
- Parallel execution and queuing

## Key Features

### Playwright (Recommended)
- Cross-browser support
- Auto-waiting mechanisms
- Video/trace recording
- Mobile emulation
- API testing
- Modern async/await syntax

### Puppeteer (Chrome-focused)
- DevTools Protocol access
- Performance profiling
- Coverage analysis
- Lightweight footprint
- Chrome extension support

## Quick Start

### Installation
```bash
# Playwright
npm install -g playwright
npx playwright install chromium

# Puppeteer  
npm install -g puppeteer
```

### Basic Scraping
```typescript
import { chromium } from 'playwright';

async function scrape(url: string) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  await page.goto(url);
  const data = await page.$$eval('.item', items =>
    items.map(item => item.textContent)
  );
  
  await browser.close();
  return data;
}
```

## Use Cases
1. Price monitoring
2. Competitive analysis
3. SEO auditing
4. Social media automation
5. Form filling
6. Report generation
7. Visual testing
8. API testing
9. Content change detection
10. Performance monitoring

## Integration
- MCP Filesystem: Save screenshots/data
- n8n: Custom automation nodes
- GitHub Actions: Scheduled scraping
- Docker: Containerized execution

## Best Practices
- Use data-testid selectors
- Implement retry logic
- Add random delays
- Rotate user agents
- Handle errors gracefully
- Optimize resource loading
- Use parallel execution
- Save state for debugging

## Quality Criteria
- 99%+ reliability
- < 5 sec per page
- Comprehensive error handling
- Anti-detection measures
- Clean, maintainable code

## Resources
- Playwright: https://playwright.dev
- Puppeteer: https://pptr.dev
- Examples: workspace/automation-examples/

## Version
v1.0.0 - 2025-10-26 - Meta Umbrella v3.0
