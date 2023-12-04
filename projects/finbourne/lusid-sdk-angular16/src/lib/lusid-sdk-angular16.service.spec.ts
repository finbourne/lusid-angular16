import { TestBed } from '@angular/core/testing';

import { LusidSdkAngular16Service } from './lusid-sdk-angular16.service';

describe('LusidSdkAngular16Service', () => {
  let service: LusidSdkAngular16Service;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LusidSdkAngular16Service);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
